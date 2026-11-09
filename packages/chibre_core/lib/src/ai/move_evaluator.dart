import 'dart:math';

import '../engine/card.dart';
import '../engine/player_view.dart';
import '../engine/seat.dart';
import 'heuristic_policy.dart';
import 'playout.dart';
import 'world_sampler.dart';

/// Estimates the value of each legal card by playing it in sampled deals and
/// finishing the round with the heuristic policy. Every card is tried on the
/// same deals so they are compared fairly.
///
/// Values are the expected advantage of the player's team over the rest of
/// the round (half the point difference, multiplier included).
class MoveEvaluator {
  MoveEvaluator(
      {required this.samples, this.policy = defaultPolicy, Random? random})
      : _random = random ?? Random();

  final int samples;

  /// Plays the rounds out.
  final CardPolicy policy;
  final Random _random;

  Map<Card, double> evaluate(PlayerView view) {
    final team = teamOf(view.seat);
    final sampler = WorldSampler(view);
    final legal = view.legalCards.cards;
    final totals = {for (final card in legal) card: 0.0};
    final start = Playout.fromView(view, sampler.hands);
    for (var i = 0; i < samples; i++) {
      final hands = sampler.sample(_random);
      for (final card in legal) {
        final playout = start.withHands(hands)..play(card);
        while (!playout.isOver) {
          final seat = playout.seatToAct;
          playout.play(policy(playout.hands[seat], playout.trick, playout.mode,
              playout.unplayed));
        }
        totals[card] = totals[card]! + playout.advantage(team);
      }
    }
    return totals.map(
        (card, total) => MapEntry(card, total / samples * view.multiplier));
  }
}
