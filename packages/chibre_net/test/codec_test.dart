import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:chibre_net/src/codec/action_codec.dart';
import 'package:chibre_net/src/codec/blunder_codec.dart';
import 'package:chibre_net/src/codec/record_codec.dart';
import 'package:chibre_net/src/codec/table_codec.dart';
import 'package:chibre_net/src/proto/chibre.pb.dart' as pb;
import 'package:test/test.dart';

GameState playedGame() => MatchRunner(
        List.generate(4, (_) => HeuristicPlayer()),
        options: const GameOptions(
            targetScore: 500,
            multipliersEnabled: true,
            finishLastRound: true))
    .playGame(deals: RandomDealSource(Random(1)));

void main() {
  test('actions survive encoding', () {
    final meld = Meld.fromCards(CardSet.parse('H6 H7 H8'))!;
    final actions = [
      const ChooseTrump(1, TrumpMode.undenufe),
      const Chibrer(2),
      PlayCard(3, Card.parse('SK'), melds: [meld], stoeck: true),
    ];
    for (final action in actions) {
      final bytes = encodeAction(action).writeToBuffer();
      expect(decodeAction(pb.Action.fromBuffer(bytes)).toString(),
          action.toString());
    }
  });

  test('a game record survives encoding and replays to the same scores', () {
    final game = playedGame();
    final bytes = encodeRecord(game.record).writeToBuffer();
    final replayed =
        replayRecord(decodeRecord(pb.GameRecord.fromBuffer(bytes)));
    expect(replayed.scores, game.scores);
    expect(replayed.winningTeam, game.winningTeam);
    expect(replayed.options.finishLastRound, isTrue);
  });

  test('a table survives encoding', () {
    final game = GameState(
        options: const GameOptions(), deals: RandomDealSource(Random(2)));
    final heuristic = HeuristicPlayer();
    for (var i = 0; i < 7; i++) {
      game.apply(heuristic.decide(game.viewFor(game.seatToAct)));
    }
    final table = TableView(
      seat: 2,
      nicknames: const ['Ana', 'Ordi 1', 'Bea', 'Ordi 2'],
      options: game.options,
      phase: TablePhase.playing,
      roundIndex: 0,
      scores: game.scores,
      player: game.viewFor(2),
      seatToAct: game.seatToAct,
      roundPoints: game.round.points,
      pausedFor: 'Ana',
      rematch: const RematchOffer(proposedBy: 0, sameCards: true),
    );
    final decoded = decodeTable(
        pb.TableSnapshot.fromBuffer(encodeTable(table).writeToBuffer()));
    final player = decoded.player!;
    expect(decoded.seat, 2);
    expect(decoded.nicknames, table.nicknames);
    expect(decoded.seatToAct, game.seatToAct);
    expect(decoded.pausedFor, 'Ana');
    expect(decoded.rematch!.sameCards, isTrue);
    expect(decoded.insights, isNull);
    expect(player.hand, table.player!.hand);
    expect(player.mode, table.player!.mode);
    expect(player.completedTricks.map((t) => t.toString()),
        table.player!.completedTricks.map((t) => t.toString()));
    expect(
        player.currentTrick.toString(), table.player!.currentTrick.toString());
    expect(player.announcedMeldValues, table.player!.announcedMeldValues);
    expect(player.legalCards, table.player!.legalCards);
  });

  test('blunders survive encoding', () {
    final blunder = Blunder(
      kind: BlunderKind.trumpChoice,
      seat: 0,
      roundIndex: 3,
      trickIndex: null,
      hand: CardSet.parse('H6 HJ'),
      trick: const [],
      mode: null,
      pointsLost: 12.5,
      chosenTrump: const TrumpOption.chibrer(),
      bestTrump: const TrumpOption.mode(TrumpMode.hearts),
    );
    final decoded = decodeBlunder(
        pb.Blunder.fromBuffer(encodeBlunder(blunder).writeToBuffer()));
    expect(decoded.kind, BlunderKind.trumpChoice);
    expect(decoded.trickIndex, isNull);
    expect(decoded.pointsLost, 12.5);
    expect(decoded.chosenTrump, const TrumpOption.chibrer());
    expect(decoded.bestTrump, const TrumpOption.mode(TrumpMode.hearts));
    expect(decoded.playedCard, isNull);
  });
}
