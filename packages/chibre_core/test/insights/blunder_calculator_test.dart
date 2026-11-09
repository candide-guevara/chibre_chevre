import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

/// Seat 0 holds the seven of diamonds (so it chooses trump) and eight spades.
/// The other seats have no melds.
final deal = dealOf({
  0: 'D7 S7 S8 S9 S10 SJ SQ SK SA',
  1: 'D6 D9 DQ H6 H9 HQ C6 C9 CQ',
  2: 'D8 DJ DA H7 H10 HK C7 C10 CK',
  3: 'D10 DK H8 HJ HA C8 CJ CA S6',
});

/// Plays one round where seat 0 makes the [scripted] decisions, in order,
/// whenever it has to act; every other decision is the heuristic player's.
GameRecord playRound(List<GameAction> scripted) {
  final game =
      GameState(options: const GameOptions(), deals: ReplayDealSource([deal]));
  final heuristic = HeuristicPlayer();
  final script = List.of(scripted);
  while (
      game.phase != GamePhase.roundOver && game.phase != GamePhase.gameOver) {
    final seat = game.seatToAct;
    final view = game.viewFor(seat);
    game.apply(seat == 0 && script.isNotEmpty
        ? script.removeAt(0)
        : heuristic.decide(view));
  }
  return game.record;
}

Map<int, List<Blunder>> analyse(GameRecord record) =>
    BlunderCalculator(samples: 30, random: Random(1))
        .analyse(record, seats: {0});

void main() {
  test('choosing a weak trump is a blunder', () {
    final record = playRound([const ChooseTrump(0, TrumpMode.diamonds)]);
    final blunders = analyse(record)[0]!;
    final trump = blunders.firstWhere((b) => b.kind == BlunderKind.trumpChoice);
    expect(trump.chosenTrump, const TrumpOption.mode(TrumpMode.diamonds));
    expect(trump.bestTrump, const TrumpOption.mode(TrumpMode.spades));
    expect(trump.pointsLost, greaterThan(20));
  });

  test('missing a meld and the stöck are blunders', () {
    final record = playRound([
      const ChooseTrump(0, TrumpMode.spades),
      PlayCard(0, c('SK')),
      PlayCard(0, c('SQ')),
    ]);
    final blunders = analyse(record)[0]!;
    expect(blunders.first.kind, BlunderKind.missedMeld);
    expect(blunders.first.pointsLost, 250);
    expect(blunders.first.missedMelds.single.value, 250);
    final stoeck =
        blunders.firstWhere((b) => b.kind == BlunderKind.missedStoeck);
    expect(stoeck.pointsLost, 20);
    expect(stoeck.playedCard, c('SQ'));
  });

  test('good play has no big blunders', () {
    final record = playRound([]);
    final blunders = analyse(record)[0]!;
    expect(blunders.every((b) => b.pointsLost < 30), isTrue,
        reason: '$blunders');
  });

  test('reports progress', () {
    final record = playRound([]);
    final progress = <double>[];
    BlunderCalculator(samples: 5, random: Random(1))
        .analyse(record, onProgress: progress.add);
    expect(progress.last, 1.0);
  });

  test('merged rounds give the blunders of the whole game', () {
    final record = MatchRunner(List.filled(seatCount, HeuristicPlayer()),
            options: const GameOptions(targetScore: 500))
        .playGame(deals: RandomDealSource(Random(3)))
        .record;
    expect(record.rounds.length, greaterThan(1));
    final whole =
        BlunderCalculator(samples: 5, random: Random(1)).analyse(record);
    final calculator = BlunderCalculator(samples: 5, random: Random(1));
    final merged = BlunderCalculator.merge([
      for (var i = 0; i < record.rounds.length; i++)
        calculator.analyseRound(record, i),
    ]);
    expect('$merged', '$whole');
    expect(merged[0], isNotEmpty);
  });
}
