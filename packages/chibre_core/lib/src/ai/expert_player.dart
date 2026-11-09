import 'dart:math';

import '../engine/game_action.dart';
import '../engine/player_view.dart';
import 'compute_budget.dart';
import 'computer_player.dart';
import 'heuristic_policy.dart';
import 'ismcts.dart';
import 'trump_evaluator.dart';

/// The expert computer player: Monte Carlo evaluation for the trump choice
/// and information set tree search for the card play.
class ExpertPlayer extends ComputerPlayer {
  ExpertPlayer(
      {this.budget = ComputeBudget.standard,
      this.policy = defaultPolicy,
      Random? random})
      : _random = random ?? Random();

  final ComputeBudget budget;

  /// Plays the rollouts of the trump evaluation and of the search.
  final CardPolicy policy;
  final Random _random;

  @override
  GameAction decideTrump(PlayerView view) {
    final values = TrumpEvaluator(
            samples: budget.trumpSamples, policy: policy, random: _random)
        .evaluate(view);
    final best = values.entries.reduce((a, b) => b.value > a.value ? b : a).key;
    return best.toAction(view.seat);
  }

  @override
  PlayCard decidePlay(PlayerView view) {
    final legal = view.legalCards.cards;
    final card = legal.length == 1
        ? legal.single
        : Ismcts(
            iterations: budget.searchIterations,
            timeLimit: budget.timeLimit,
            policy: policy,
            random: _random,
          ).search(view);
    return playWithAnnouncements(view, card);
  }
}
