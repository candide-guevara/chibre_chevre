import 'dart:isolate';

import 'package:chibre_core/chibre_core.dart';

import 'bot_runner.dart';

/// Computes in a background isolate so the UI stays responsive.
class IsolateBotRunner implements BotRunner {
  const IsolateBotRunner({this.budget = ComputeBudget.standard});

  final ComputeBudget budget;

  @override
  Future<GameAction> decide(PlayerView view) => _decide(budget, view);

  @override
  Future<Map<int, List<Blunder>>> analyse(GameRecord record) =>
      _analyse(budget, record);

  // Static so the isolate closures capture nothing but their arguments.
  static Future<GameAction> _decide(ComputeBudget budget, PlayerView view) =>
      Isolate.run(() => ExpertPlayer(budget: budget).decide(view));

  static Future<Map<int, List<Blunder>>> _analyse(
          ComputeBudget budget, GameRecord record) =>
      Isolate.run(() =>
          BlunderCalculator(samples: budget.analysisSamples).analyse(record));
}
