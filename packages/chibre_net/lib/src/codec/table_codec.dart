import 'package:chibre_core/chibre_core.dart';

import '../proto/chibre.pb.dart' as pb;
import '../session/card_style.dart';
import '../session/table_view.dart';
import 'basic_codec.dart';
import 'blunder_codec.dart';

pb.TableSnapshot encodeTable(TableView table) {
  final player = table.player;
  final snapshot = pb.TableSnapshot(
    viewer: table.seat,
    nicknames: table.nicknames,
    options: encodeOptions(table.options),
    cardStyle: pb.CardStyle.valueOf(table.cardStyle.index),
    phase: pb.TableSnapshot_Phase.valueOf(table.phase.index),
    roundIndex: table.roundIndex,
    seatToAct: encodeOptional(table.seatToAct),
    scores: table.scores,
    roundPoints: table.roundPoints,
    winningTeam: encodeOptional(table.winningTeam),
    pausedFor: table.pausedFor ?? '',
    trickHoldMs: table.trickHold.inMilliseconds,
    recapFor: table.recapFor,
    meldChoiceFor: table.meldChoiceFor,
  );
  if (player != null) {
    snapshot
      ..hand = encodeCards(player.hand)
      ..mode = encodeMode(player.mode)
      ..trumpChooser = player.trumpChooser
      ..chibred = player.chibred
      ..completedTricks.addAll(player.completedTricks.map(_encodeTrick))
      ..melds.addAll([
        for (var seat = 0; seat < seatCount; seat++)
          pb.SeatMelds(
            announcedValues: player.announcedMeldValues[seat],
            revealed: [
              for (final meld in player.revealedMelds[seat])
                encodeCards(meld.cards),
            ],
          ),
      ])
      ..stoeckSeat = encodeOptional(player.stoeckSeat);
    if (player.currentTrick != null) {
      snapshot.currentTrick = _encodeTrick(player.currentTrick!);
    }
  }
  if (table.rematch != null) {
    snapshot.rematch = pb.RematchProposal(
      proposedBy: table.rematch!.proposedBy,
      sameCards: table.rematch!.sameCards,
    );
  }
  if (table.insights != null) {
    snapshot.insights =
        pb.Insights(blunders: table.insights!.map(encodeBlunder));
  }
  return snapshot;
}

TableView decodeTable(pb.TableSnapshot snapshot) {
  final phase = TablePhase.values[snapshot.phase.value];
  final options = decodeOptions(snapshot.options);
  final scores = List<int>.unmodifiable(snapshot.scores);
  return TableView(
    seat: snapshot.viewer,
    nicknames: List.unmodifiable(snapshot.nicknames),
    options: options,
    cardStyle: CardStyle.values[snapshot.cardStyle.value],
    trickHold: Duration(milliseconds: snapshot.trickHoldMs),
    recapFor: List.unmodifiable(snapshot.recapFor),
    meldChoiceFor: List.unmodifiable(snapshot.meldChoiceFor),
    phase: phase,
    roundIndex: snapshot.roundIndex,
    scores: scores,
    player: phase == TablePhase.waitingForPlayer
        ? null
        : _decodePlayer(snapshot, options, scores),
    seatToAct: decodeOptional(snapshot.seatToAct),
    roundPoints: List.unmodifiable(snapshot.roundPoints),
    winningTeam: decodeOptional(snapshot.winningTeam),
    pausedFor: snapshot.pausedFor.isEmpty ? null : snapshot.pausedFor,
    rematch: snapshot.hasRematch()
        ? RematchOffer(
            proposedBy: snapshot.rematch.proposedBy,
            sameCards: snapshot.rematch.sameCards,
          )
        : null,
    insights: snapshot.hasInsights()
        ? List.unmodifiable(snapshot.insights.blunders.map(decodeBlunder))
        : null,
  );
}

PlayerView _decodePlayer(
        pb.TableSnapshot snapshot, GameOptions options, List<int> scores) =>
    PlayerView(
      seat: snapshot.viewer,
      options: options,
      hand: decodeCards(snapshot.hand),
      mode: decodeMode(snapshot.mode),
      trumpChooser: snapshot.trumpChooser,
      chibred: snapshot.chibred,
      completedTricks: [
        for (final trick in snapshot.completedTricks) _decodeTrick(trick),
      ],
      currentTrick: snapshot.hasCurrentTrick()
          ? _decodeTrick(snapshot.currentTrick)
          : null,
      announcedMeldValues: [
        for (final melds in snapshot.melds) List.of(melds.announcedValues),
      ],
      revealedMelds: [
        for (final melds in snapshot.melds)
          melds.revealed.map(decodeMeld).toList(),
      ],
      stoeckSeat: decodeOptional(snapshot.stoeckSeat),
      scores: scores,
    );

pb.Trick _encodeTrick(Trick trick) => pb.Trick(
      leader: trick.leader,
      cards: [for (final card in trick.cards) card.index],
    );

Trick _decodeTrick(pb.Trick trick) => Trick(
      trick.leader,
      [for (final index in trick.cards) Card.fromIndex(index)],
    );
