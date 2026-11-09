import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:chibre_core/chibre_core.dart';

import 'variants.dart';

const _usage = '''
Compares two playing algorithms on single rounds: each deal is played
twice with the teams swapped, so that luck cancels out.

Usage: dart run bin/algo_match.dart <a> <b> [--pairs <n>] [--seed <n>]
       dart run bin/algo_match.dart <a> <b> --games <pairs> [--seed <n>]
  --pairs   pairs of rounds (default 200): a's points minus b's per round,
            and the time per decision
  --games   pairs of whole games of 1000 points instead: a's win rate
Variants (bin/variants.dart): ${'{variants}'}
''';

Future<void> main(List<String> args) async {
  if (args.length < 2 ||
      !variants.containsKey(args[0]) ||
      !variants.containsKey(args[1])) {
    stdout.write(_usage.replaceFirst('{variants}', variants.keys.join(', ')));
    exit(64);
  }
  final options = <String, String>{};
  for (var i = 2; i + 1 < args.length; i += 2) {
    options[args[i].substring(2)] = args[i + 1];
  }
  final a = args[0];
  final b = args[1];
  final pairs = int.parse(options['pairs'] ?? '200');
  final seed = int.parse(options['seed'] ?? '1');
  if (options.containsKey('games')) {
    return _games(a, b, int.parse(options['games']!), seed);
  }

  final stopwatch = Stopwatch()..start();
  final results = <_Pair>[];
  var next = 0;
  Future<void> worker() async {
    while (next < pairs) {
      final pair = seed * 100000 + next++;
      results.add(await Isolate.run(() => _playPair(a, b, pair)));
      stdout.write('\r${results.length}/$pairs pairs '
          '(${stopwatch.elapsed.inMinutes} min)');
    }
  }

  await Future.wait(
      [for (var i = 0; i < Platform.numberOfProcessors - 1; i++) worker()]);
  stdout.writeln();

  final margins = [for (final r in results) r.margin];
  final mean = margins.reduce((x, y) => x + y) / margins.length;
  final variance =
      margins.fold(0.0, (sum, m) => sum + (m - mean) * (m - mean)) /
          (margins.length - 1);
  final error = 1.96 * sqrt(variance / margins.length);
  final aWins = results.where((r) => r.margin > 0).length;
  final bWins = results.where((r) => r.margin < 0).length;
  String ms(List<int> micros) {
    final sorted = List.of(micros)..sort();
    final mean = sorted.reduce((x, y) => x + y) / sorted.length;
    return 'median ${(sorted[sorted.length ~/ 2] / 1000).toStringAsFixed(0)}'
        ' ms, mean ${(mean / 1000).toStringAsFixed(0)} ms';
  }

  stdout.writeln('$a vs $b, ${results.length} pairs of rounds: '
      '$a ${mean >= 0 ? '+' : ''}${mean.toStringAsFixed(1)} '
      '± ${error.toStringAsFixed(1)} points per round; '
      'better on $aWins pairs, worse on $bWins');
  for (final (name, index) in [(a, 0), (b, 1)]) {
    stdout.writeln('  $name: card ${ms([
          for (final r in results) ...r.cardTimes[index]
        ])}, trump ${ms([for (final r in results) ...r.trumpTimes[index]])}');
  }
}

class _Pair {
  _Pair(this.margin, this.cardTimes, this.trumpTimes);

  /// a's points minus b's, averaged over the two rounds.
  final double margin;
  final List<List<int>> cardTimes;
  final List<List<int>> trumpTimes;
}

_Pair _playPair(String a, String b, int pair) {
  final random = Random(pair);
  final deal = RandomDealSource(random).nextDeal();
  final chooser = random.nextInt(seatCount);
  final players = [
    _Timed(variants[a]!(Random(pair * 2))),
    _Timed(variants[b]!(Random(pair * 2 + 1))),
  ];
  var margin = 0.0;
  for (final aTeam in [0, 1]) {
    final seats = [
      for (var seat = 0; seat < seatCount; seat++)
        players[teamOf(seat) == aTeam ? 0 : 1]
    ];
    final round = MatchRunner(seats).playRound(deal, trumpChooser: chooser);
    margin += (round.points[aTeam] - round.points[1 - aTeam]) / 2;
  }
  return _Pair(margin, [for (final p in players) p.cardTimes],
      [for (final p in players) p.trumpTimes]);
}

/// Records how long each decision with a choice takes.
class _Timed extends ComputerPlayer {
  _Timed(this.inner);

  final ComputerPlayer inner;
  final cardTimes = <int>[];
  final trumpTimes = <int>[];

  @override
  GameAction decideTrump(PlayerView view) {
    final stopwatch = Stopwatch()..start();
    final action = inner.decideTrump(view);
    trumpTimes.add(stopwatch.elapsedMicroseconds);
    return action;
  }

  @override
  PlayCard decidePlay(PlayerView view) {
    final stopwatch = Stopwatch()..start();
    final action = inner.decidePlay(view);
    if (view.legalCards.length > 1) {
      cardTimes.add(stopwatch.elapsedMicroseconds);
    }
    return action;
  }
}

/// Whole games of 1000 points, in pairs on the same deals with the teams
/// swapped.
Future<void> _games(String a, String b, int pairs, int seed) async {
  final jobs = [
    for (var pair = 0; pair < pairs; pair++)
      for (final aTeam in [0, 1]) (seed * 100000 + pair, aTeam)
  ];
  final stopwatch = Stopwatch()..start();
  final aWon = <bool>[];
  var next = 0;
  Future<void> worker() async {
    while (next < jobs.length) {
      final (pair, aTeam) = jobs[next++];
      aWon.add(await Isolate.run(() {
        final pa = variants[a]!(Random(pair * 2));
        final pb = variants[b]!(Random(pair * 2 + 1));
        final players = [
          for (var seat = 0; seat < seatCount; seat++)
            teamOf(seat) == aTeam ? pa : pb
        ];
        final game = MatchRunner(players)
            .playGame(deals: RandomDealSource(Random(pair)));
        return game.winningTeam == aTeam;
      }));
      stdout.write('\r${aWon.length}/${jobs.length} games '
          '(${stopwatch.elapsed.inMinutes} min)');
    }
  }

  await Future.wait(
      [for (var i = 0; i < Platform.numberOfProcessors - 1; i++) worker()]);
  stdout.writeln();
  final wins = aWon.where((w) => w).length;
  final rate = wins / aWon.length;
  stdout.writeln('$a vs $b: $a wins $wins/${aWon.length} games '
      '(${(rate * 100).toStringAsFixed(1)}% '
      '± ${(196 * sqrt(rate * (1 - rate) / aWon.length)).toStringAsFixed(1)}%)');
}
