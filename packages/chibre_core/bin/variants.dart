import 'dart:math';

import 'package:chibre_core/chibre_core.dart';

/// The playing algorithms compared by algo_match.dart: the expert player
/// with a given number of search iterations, and the policy of its
/// rollouts (v1 or v2, the default).
final Map<String, ComputerPlayer Function(Random)> variants = {
  for (final iterations in [1000, 8700, 50000])
    for (final (name, policy) in [
      ('v1', heuristicCard),
      ('v2', heuristicCardV2),
    ])
      'expert$iterations$name': (random) => ExpertPlayer(
          budget: _budget(iterations), policy: policy, random: random),
};

/// The app's budget for [iterations] search iterations, without time limit.
ComputeBudget _budget(int iterations) => ComputeBudget(
      searchIterations: iterations,
      trumpSamples: iterations ~/ 7,
      analysisSamples: 0,
    );
