import 'dart:io';
import 'dart:math';

import 'package:chibre_core/chibre_core.dart';

const _usage = '''
Compares two computer players on the same deals, each deal being played
twice with the teams swapped (duplicate format) to cancel out luck.

Usage: dart run bin/simulate.dart [options]
  --a <player>        first player: expert, heuristic or random (default expert)
  --b <player>        second player (default heuristic)
  --deals <n>         number of deals (default 20)
  --iterations <n>    expert search iterations (default: from benchmark)
  --seed <n>          random seed (default 1)
  --oben-unde         allow obenabe and undenufe
''';

void main(List<String> args) {
  final options = _parse(args);
  if (options == null) {
    stdout.write(_usage);
    exit(64);
  }

  final random = Random(int.parse(options['seed'] ?? '1'));
  final budget = _budget(options['iterations']);
  final gameOptions =
      GameOptions(obenUndeAllowed: options.containsKey('oben-unde'));
  final nameA = options['a'] ?? 'expert';
  final nameB = options['b'] ?? 'heuristic';
  final a = _player(nameA, budget, random);
  final b = _player(nameB, budget, random);
  final deals = int.parse(options['deals'] ?? '20');

  stdout.writeln('$nameA vs $nameB, $deals deals, '
      '${budget.searchIterations} search iterations');
  final totals = [0, 0];
  final stopwatch = Stopwatch()..start();
  for (var i = 0; i < deals; i++) {
    final deal = randomDeal(random);
    final chooser = random.nextInt(seatCount);
    // a sits on team 0, then on team 1.
    final first = MatchRunner([a, b, a, b], options: gameOptions)
        .playRound(deal, trumpChooser: chooser);
    final second = MatchRunner([b, a, b, a], options: gameOptions)
        .playRound(deal, trumpChooser: chooser);
    totals[0] += first.points[0] + second.points[1];
    totals[1] += first.points[1] + second.points[0];
    stdout.writeln('deal ${i + 1}: $nameA ${first.points[0]} + '
        '${second.points[1]}, $nameB ${first.points[1]} + ${second.points[0]}');
  }
  final rounds = deals * 2;
  stdout.writeln('average points per round: '
      '$nameA ${(totals[0] / rounds).toStringAsFixed(1)}, '
      '$nameB ${(totals[1] / rounds).toStringAsFixed(1)} '
      '(${stopwatch.elapsed.inSeconds}s)');
}

Map<String, String>? _parse(List<String> args) {
  final options = <String, String>{};
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (!arg.startsWith('--')) return null;
    final name = arg.substring(2);
    if (name == 'oben-unde') {
      options[name] = 'true';
    } else if (i + 1 < args.length) {
      options[name] = args[++i];
    } else {
      return null;
    }
  }
  return options;
}

ComputeBudget _budget(String? iterations) {
  if (iterations != null) {
    final n = int.parse(iterations);
    return ComputeBudget(
        searchIterations: n, trumpSamples: n ~/ 7, analysisSamples: n ~/ 20);
  }
  final speed = measurePlayoutsPerSecond();
  stdout.writeln('benchmark: ${speed.round()} playouts/s');
  return ComputeBudget.forSpeed(speed);
}

ComputerPlayer _player(String name, ComputeBudget budget, Random random) =>
    switch (name) {
      'expert' => ExpertPlayer(budget: budget, random: random),
      'heuristic' => HeuristicPlayer(),
      'random' => RandomPlayer(random),
      _ => throw ArgumentError('Unknown player $name'),
    };
