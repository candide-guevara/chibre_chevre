import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:chibre_core/chibre_core.dart';

const _usage = '''
Measures how much a bigger thinking budget helps: expert teams with
different budgets play whole games against each other. Each game is played
twice on the same deals with the teams swapped, to cancel out luck.

Budgets are thinking times on a phone, turned into iterations with
ComputeBudget.forSpeed and no time limit, so that results don't depend on
how fast or busy this machine is.

Usage: dart run bin/budget_match.dart [options]
  --budgets <s,s,...>   thinking times in seconds (default 0.6,0.8,1.0)
  --phone-speed <n>     the phone's search iterations per second (default 8000)
  --pairs <n>           pairs of games per matchup (default 50)
  --target <n>          points to win a game (default 1000)
  --isolates <n>        games played in parallel (default: processors - 1)
  --seed <n>            random seed (default 1)
''';

Future<void> main(List<String> args) async {
  final options = _parse(args);
  if (options == null) {
    stdout.write(_usage);
    exit(64);
  }
  final budgets = (options['budgets'] ?? '0.6,0.8,1.0')
      .split(',')
      .map(double.parse)
      .toList();
  final speed = double.parse(options['phone-speed'] ?? '8000');
  final pairs = int.parse(options['pairs'] ?? '50');
  final target = int.parse(options['target'] ?? '1000');
  final isolates =
      int.parse(options['isolates'] ?? '${Platform.numberOfProcessors - 1}');
  final seed = int.parse(options['seed'] ?? '1');

  for (final budget in budgets) {
    final b = _budget(speed, budget);
    stdout.writeln('${budget}s: ${b.searchIterations} search iterations, '
        '${b.trumpSamples} trump samples');
  }

  final matchups = [
    for (var i = 0; i < budgets.length; i++)
      for (var j = i + 1; j < budgets.length; j++) (budgets[i], budgets[j]),
  ];
  final jobs = [
    for (final (low, high) in matchups)
      for (var pair = 0; pair < pairs; pair++)
        for (final highOnTeam0 in [true, false])
          _Job(low, high, speed, target, seed * 100000 + pair, highOnTeam0),
  ];

  final stopwatch = Stopwatch()..start();
  final results = <_Result>[];
  var next = 0;
  Future<void> worker() async {
    while (next < jobs.length) {
      final job = jobs[next++];
      results.add(await Isolate.run(job.play));
      stdout.write('\r${results.length}/${jobs.length} games '
          '(${stopwatch.elapsed.inMinutes} min)');
    }
  }

  await Future.wait([for (var i = 0; i < isolates; i++) worker()]);
  stdout.writeln();

  for (final (low, high) in matchups) {
    final games =
        results.where((r) => r.job.low == low && r.job.high == high).toList();
    final wins = games.where((r) => r.highWon).length;
    final rate = wins / games.length;
    final error = 1.96 * sqrt(rate * (1 - rate) / games.length);
    // Each pair of games on the same deals gives one measure of the margin.
    final pairMargins = <int, double>{};
    for (final r in games) {
      pairMargins.update(r.job.dealSeed, (m) => m + r.marginPerRound / 2,
          ifAbsent: () => r.marginPerRound / 2);
    }
    final margins = pairMargins.values.toList();
    final margin = margins.reduce((a, b) => a + b) / margins.length;
    final variance =
        margins.fold(0.0, (sum, m) => sum + (m - margin) * (m - margin)) /
            (margins.length - 1);
    final marginError = 1.96 * sqrt(variance / margins.length);
    stdout.writeln('${high}s vs ${low}s: ${high}s wins $wins/${games.length} '
        '(${_percent(rate)} ± ${_percent(error)}), '
        '${margin >= 0 ? '+' : ''}${margin.toStringAsFixed(1)} '
        '± ${marginError.toStringAsFixed(1)} points per round');
  }
}

String _percent(double value) => '${(value * 100).toStringAsFixed(1)}%';

ComputeBudget _budget(double speed, double seconds) {
  final budget = ComputeBudget.forSpeed(speed,
      target: Duration(microseconds: (seconds * 1e6).round()));
  return ComputeBudget(
    searchIterations: budget.searchIterations,
    trumpSamples: budget.trumpSamples,
    analysisSamples: budget.analysisSamples,
  );
}

/// One game: the [high] budget team against the [low] one.
class _Job {
  const _Job(this.low, this.high, this.speed, this.target, this.dealSeed,
      this.highOnTeam0);

  final double low;
  final double high;
  final double speed;
  final int target;

  /// The two games of a pair are dealt the same cards.
  final int dealSeed;
  final bool highOnTeam0;

  _Result play() {
    final random = Random(dealSeed * 2 + (highOnTeam0 ? 0 : 1));
    final strong = ExpertPlayer(budget: _budget(speed, high), random: random);
    final weak = ExpertPlayer(budget: _budget(speed, low), random: random);
    final players = highOnTeam0
        ? [strong, weak, strong, weak]
        : [weak, strong, weak, strong];
    final game = MatchRunner(players, options: GameOptions(targetScore: target))
        .playGame(deals: RandomDealSource(Random(dealSeed)));
    final highTeam = highOnTeam0 ? 0 : 1;
    return _Result(
      this,
      highWon: game.winningTeam == highTeam,
      highMargin: game.scores[highTeam] - game.scores[1 - highTeam],
      rounds: game.roundIndex + 1,
    );
  }
}

class _Result {
  const _Result(this.job,
      {required this.highWon, required this.highMargin, required this.rounds});

  final _Job job;
  final bool highWon;
  final int highMargin;
  final int rounds;

  double get marginPerRound => highMargin / rounds;
}

Map<String, String>? _parse(List<String> args) {
  final options = <String, String>{};
  for (var i = 0; i < args.length; i += 2) {
    if (!args[i].startsWith('--') || i + 1 >= args.length) return null;
    options[args[i].substring(2)] = args[i + 1];
  }
  return options;
}
