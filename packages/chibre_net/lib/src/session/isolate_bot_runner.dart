import 'dart:isolate';
import 'dart:math';

import 'package:chibre_core/chibre_core.dart';

import 'bot_runner.dart';

/// Computes in a background isolate so the UI stays responsive.
class IsolateBotRunner implements BotRunner {
  const IsolateBotRunner({this.budget = ComputeBudget.standard, this.seed});

  final ComputeBudget budget;

  /// When set, every decision searches with this seed, so the same position
  /// gets the same move (unless the search hits its time limit).
  final int? seed;

  @override
  Future<GameAction> decide(PlayerView view) => _decide(budget, seed, view);

  @override
  Future<Map<int, List<Blunder>>?> analyseRound(
          GameRecord record, int roundIndex,
          {Duration? timeLimit}) =>
      _analyseRound(budget, record, roundIndex, timeLimit);

  // Static so the isolate closures capture nothing but their arguments.
  static Future<GameAction> _decide(
          ComputeBudget budget, int? seed, PlayerView view) =>
      Isolate.run(() => ExpertPlayer(
            budget: budget,
            random: seed == null ? null : Random(seed),
          ).decide(view));

  static Future<Map<int, List<Blunder>>?> _analyseRound(ComputeBudget budget,
          GameRecord record, int roundIndex, Duration? timeLimit) =>
      Isolate.run(() => BlunderCalculator(samples: budget.analysisSamples)
          .analyseRound(record, roundIndex, timeLimit: timeLimit));
}
