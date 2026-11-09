import 'dart:math';

import 'package:chibre_core/chibre_core.dart';

import 'bot_runner.dart';

/// Computes on the calling isolate. Fine for tests and command line tools;
/// the app uses [IsolateBotRunner] so the UI never freezes.
class InlineBotRunner implements BotRunner {
  InlineBotRunner({this.budget = ComputeBudget.standard, Random? random})
      : _random = random ?? Random();

  final ComputeBudget budget;
  final Random _random;

  @override
  Future<GameAction> decide(PlayerView view) async =>
      ExpertPlayer(budget: budget, random: _random).decide(view);

  @override
  Future<Map<int, List<Blunder>>?> analyseRound(
          GameRecord record, int roundIndex,
          {Set<int> seats = const {0, 2}, Duration? timeLimit}) async =>
      BlunderCalculator(samples: budget.analysisSamples, random: _random)
          .analyseRound(record, roundIndex, seats: seats, timeLimit: timeLimit);
}
