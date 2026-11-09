import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:chibre_core/chibre_core.dart';

const _usage = '''
Measures how long the insights take, per round and per game: a weak
expert team plays a strong one, then the weak team's decisions are
analysed round by round, one game at a time. Games come in pairs on the
same deals with the teams swapped, which also measures how much weaker the
weak team is.

Thinking times are turned into iterations at this machine's speed. The
analysis budget is capped at 500 samples per decision, which this machine
reaches but phones don't: --samples overrides it, e.g. to the uncapped
value, whose time here is what any uncapped phone waits.

Usage: dart run bin/insights_bench.dart [options]
  --pairs <n>      pairs of games (default 12)
  --weak <s>       the weak team's thinking time (default 0.1)
  --strong <s>     the strong team's thinking time (default 0.6)
  --analysis <s>   the thinking time the analysis budget is derived from
                   (default 0.6, as in the app)
  --speed <n>      search iterations per second (default: measured)
  --samples <n,n,...>  samples per analysed decision, instead of the
                   budget's
''';

Future<void> main(List<String> args) async {
  final options = <String, String>{};
  for (var i = 0; i < args.length; i += 2) {
    if (!args[i].startsWith('--') || i + 1 >= args.length) {
      stdout.write(_usage);
      exit(64);
    }
    options[args[i].substring(2)] = args[i + 1];
  }
  final games = 2 * int.parse(options['pairs'] ?? '12');
  final weak = double.parse(options['weak'] ?? '0.1');
  final strong = double.parse(options['strong'] ?? '0.6');
  final analysis = double.parse(options['analysis'] ?? '0.6');

  final speed = options.containsKey('speed')
      ? double.parse(options['speed']!)
      : measurePlayoutsPerSecond();
  final samplings = options.containsKey('samples')
      ? options['samples']!.split(',').map(int.parse).toList()
      : [_budget(speed, analysis).analysisSamples];
  stdout.writeln('${speed.round()} iterations/s: '
      '${_budget(speed, weak).searchIterations} iterations for the weak team, '
      '${_budget(speed, strong).searchIterations} for the strong one, '
      '${samplings.join(' or ')} samples per analysed decision');

  final stopwatch = Stopwatch()..start();
  final results = <_Result>[];
  var next = 0;
  Future<void> worker() async {
    while (next < games) {
      final seed = next++;
      results.add(await Isolate.run(() => _play(seed, speed, weak, strong)));
      stdout.write('\r${results.length}/$games games played '
          '(${stopwatch.elapsed.inMinutes} min)');
    }
  }

  await Future.wait(
      [for (var i = 0; i < Platform.numberOfProcessors - 1; i++) worker()]);
  stdout.writeln();

  results.sort((a, b) => a.seed - b.seed);
  final wins = results.where((r) => r.weakWon).length;
  final margins = [
    for (var i = 0; i < results.length; i += 2)
      (results[i].weakMarginPerRound + results[i + 1].weakMarginPerRound) / 2
  ];
  final margin = margins.reduce((a, b) => a + b) / margins.length;
  final variance =
      margins.fold(0.0, (sum, m) => sum + (m - margin) * (m - margin)) /
          (margins.length - 1);
  stdout.writeln('the weak team wins $wins/${results.length} games, '
      '${margin.toStringAsFixed(1)} '
      '± ${(1.96 * sqrt(variance / margins.length)).toStringAsFixed(1)} '
      'points per round');
  for (final samples in samplings) {
    _analyse(results, samples);
  }
}

void _analyse(List<_Result> results, int samples) {
  final totals = <double>[];
  final rounds = <double>[];
  final lastRounds = <double>[];
  var decisions = 0;
  var blunders = 0;
  for (final (index, result) in results.indexed) {
    final record = result.record;
    final seats = result.weakSeats;
    for (final round in record.rounds) {
      decisions += round.actions.where((a) => seats.contains(a.seat)).length;
    }
    final calculator =
        BlunderCalculator(samples: samples, random: Random(index));
    final laps = <double>[];
    final perRound = <Map<int, List<Blunder>>>[];
    for (var round = 0; round < record.rounds.length; round++) {
      final timer = Stopwatch()..start();
      perRound.add(calculator.analyseRound(record, round, seats: seats));
      laps.add(timer.elapsedMicroseconds / 1e6);
    }
    final found = BlunderCalculator.merge(perRound, seats: seats);
    blunders += found.values.fold(0, (sum, b) => sum + b.length);
    totals.add(laps.reduce((a, b) => a + b));
    rounds.addAll(laps);
    lastRounds.add(laps.last);
    stdout.write('\r${index + 1}/${results.length} games analysed');
  }
  stdout.writeln();

  stdout.writeln('$samples samples: ${rounds.length} rounds, '
      '${(decisions / results.length).round()} weak-team decisions per game, '
      '$blunders blunders shown');
  stdout.writeln('  one round:  ${_stats(rounds)}');
  stdout.writeln('  last round: ${_stats(lastRounds)}');
  stdout.writeln('  whole game: ${_stats(totals)}');
}

String _stats(List<double> seconds) {
  final sorted = List.of(seconds)..sort();
  String s(double value) => '${value.toStringAsFixed(2)} s';
  return 'median ${s(sorted[sorted.length ~/ 2])}, '
      'mean ${s(sorted.reduce((a, b) => a + b) / sorted.length)}, '
      'max ${s(sorted.last)}';
}

ComputeBudget _budget(double speed, double seconds) {
  final budget = ComputeBudget.forSpeed(speed,
      target: Duration(microseconds: (seconds * 1e6).round()));
  return ComputeBudget(
    searchIterations: budget.searchIterations,
    trumpSamples: budget.trumpSamples,
    analysisSamples: budget.analysisSamples,
  );
}

/// Games 2n and 2n + 1 are dealt the same cards, the weak team on seats 0
/// and 2 in the first, 1 and 3 in the second.
_Result _play(int seed, double speed, double weak, double strong) {
  final random = Random(seed);
  final weakPlayer = ExpertPlayer(budget: _budget(speed, weak), random: random);
  final strongPlayer =
      ExpertPlayer(budget: _budget(speed, strong), random: random);
  final weakTeam = seed % 2;
  final players = weakTeam == 0
      ? [weakPlayer, strongPlayer, weakPlayer, strongPlayer]
      : [strongPlayer, weakPlayer, strongPlayer, weakPlayer];
  final game =
      MatchRunner(players).playGame(deals: RandomDealSource(Random(seed ~/ 2)));
  return _Result(
    seed: seed,
    record: game.record,
    weakSeats: {weakTeam, weakTeam + 2},
    weakWon: game.winningTeam == weakTeam,
    weakMarginPerRound: (game.scores[weakTeam] - game.scores[1 - weakTeam]) /
        game.record.rounds.length,
  );
}

class _Result {
  const _Result({
    required this.seed,
    required this.record,
    required this.weakSeats,
    required this.weakWon,
    required this.weakMarginPerRound,
  });

  final int seed;
  final GameRecord record;
  final Set<int> weakSeats;
  final bool weakWon;
  final double weakMarginPerRound;
}
