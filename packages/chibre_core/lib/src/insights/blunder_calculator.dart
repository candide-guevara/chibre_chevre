import 'dart:math';

import '../ai/move_evaluator.dart';
import '../ai/trump_evaluator.dart';
import '../ai/trump_option.dart';
import '../engine/card.dart';
import '../engine/game_action.dart';
import '../engine/game_record.dart';
import '../engine/game_state.dart';
import '../engine/meld.dart';
import '../engine/meld_comparison.dart';
import '../engine/meld_finder.dart';
import '../engine/player_view.dart';
import '../engine/seat.dart';
import '../engine/stoeck.dart';
import 'blunder.dart';

/// Replays a finished game and compares each decision of the analysed seats
/// with the best alternative, given what the player knew at the time.
class BlunderCalculator {
  BlunderCalculator({required this.samples, Random? random})
      : _random = random ?? Random();

  /// Sampled deals per analysed decision.
  final int samples;
  final Random _random;

  /// Smaller losses are estimation noise rather than blunders.
  static const minimumLoss = 1.0;

  /// The [maxPerSeat] biggest blunders of each of [seats], worst first.
  Map<int, List<Blunder>> analyse(
    GameRecord record, {
    Set<int> seats = const {0, 2},
    int maxPerSeat = 3,
    void Function(double progress)? onProgress,
  }) {
    final total = record.rounds.fold(0, (sum, r) => sum + r.actions.length);
    var done = 0;
    final blunders = <Blunder>[];
    final game = GameState.replaying(record);
    for (final (roundIndex, round) in record.rounds.indexed) {
      if (roundIndex > 0) game.startNextRound();
      for (final action in round.actions) {
        if (seats.contains(action.seat)) {
          final view = game.viewFor(action.seat);
          blunders.addAll(_judge(view, action, round, roundIndex));
        }
        game.apply(action);
        onProgress?.call(++done / total);
      }
    }
    return {
      for (final seat in seats)
        seat: _worst(blunders.where((b) => b.seat == seat), maxPerSeat),
    };
  }

  List<Blunder> _worst(Iterable<Blunder> blunders, int count) =>
      (blunders.where((b) => b.pointsLost >= minimumLoss).toList()
            ..sort((a, b) => b.pointsLost.compareTo(a.pointsLost)))
          .take(count)
          .toList();

  Iterable<Blunder> _judge(PlayerView view, GameAction action,
          RoundRecord round, int roundIndex) =>
      switch (action) {
        ChooseTrump() || Chibrer() => [_judgeTrump(view, action, roundIndex)],
        PlayCard() => [
            _judgeCard(view, action, roundIndex),
            _judgeMelds(view, action, round, roundIndex),
            _judgeStoeck(view, action, roundIndex),
          ].whereType<Blunder>(),
      };

  Blunder _judgeTrump(PlayerView view, GameAction action, int roundIndex) {
    final values =
        TrumpEvaluator(samples: samples, random: _random).evaluate(view);
    final chosen = TrumpOption.ofAction(action);
    final best = values.entries.reduce((a, b) => b.value > a.value ? b : a);
    return _blunder(view, BlunderKind.trumpChoice, roundIndex,
        pointsLost: best.value - values[chosen]!,
        chosenTrump: chosen,
        bestTrump: best.key);
  }

  Blunder? _judgeCard(PlayerView view, PlayCard action, int roundIndex) {
    if (view.legalCards.length == 1) return null;
    final values =
        MoveEvaluator(samples: samples, random: _random).evaluate(view);
    final best = values.entries.reduce((a, b) => b.value > a.value ? b : a);
    return _blunder(view, BlunderKind.cardPlay, roundIndex,
        pointsLost: best.value - values[action.card]!,
        playedCard: action.card,
        bestCard: best.key);
  }

  /// Compares, with the melds everyone actually announced, the meld points
  /// the team scored with those it would have scored announcing everything.
  Blunder? _judgeMelds(
      PlayerView view, PlayCard action, RoundRecord round, int roundIndex) {
    if (!view.mayAnnounceMelds) return null;
    final best = findBestMelds(view.hand);
    final announced = action.melds.toSet();
    final missed = best.where((meld) => !announced.contains(meld)).toList();
    if (missed.isEmpty) return null;

    final actual = List<List<Meld>>.filled(seatCount, const []);
    for (final play in round.actions.whereType<PlayCard>()) {
      if (play.melds.isNotEmpty) actual[play.seat] = play.melds;
    }
    final ideal = List.of(actual)..[view.seat] = best;
    final team = teamOf(view.seat);
    int teamPoints(List<List<Meld>> melds) =>
        winningMeldTeam(melds, view.mode!, round.trumpChooser) == team
            ? teamMeldPoints(melds, team)
            : 0;
    final lost = (teamPoints(ideal) - teamPoints(actual)) * view.multiplier;
    return _blunder(view, BlunderKind.missedMeld, roundIndex,
        pointsLost: lost.toDouble(), missedMelds: missed);
  }

  Blunder? _judgeStoeck(PlayerView view, PlayCard action, int roundIndex) {
    final missed = !action.stoeck &&
        view.stoeckSeat == null &&
        completesStoeck(action.card, view.playedBy(view.seat), view.mode!);
    if (!missed) return null;
    return _blunder(view, BlunderKind.missedStoeck, roundIndex,
        pointsLost: (stoeckPoints * view.multiplier).toDouble(),
        playedCard: action.card);
  }

  Blunder _blunder(
    PlayerView view,
    BlunderKind kind,
    int roundIndex, {
    required double pointsLost,
    Card? playedCard,
    Card? bestCard,
    TrumpOption? chosenTrump,
    TrumpOption? bestTrump,
    List<Meld> missedMelds = const [],
  }) =>
      Blunder(
        kind: kind,
        seat: view.seat,
        roundIndex: roundIndex,
        trickIndex: view.mode == null ? null : view.completedTricks.length,
        hand: view.hand,
        trick: view.currentTrick?.cards ?? const [],
        mode: view.mode,
        pointsLost: pointsLost,
        playedCard: playedCard,
        bestCard: bestCard,
        chosenTrump: chosenTrump,
        bestTrump: bestTrump,
        missedMelds: missedMelds,
      );
}
