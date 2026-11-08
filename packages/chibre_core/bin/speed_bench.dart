import 'dart:io';
import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_core/src/ai/ismcts.dart';
import 'package:chibre_core/src/ai/move_evaluator.dart';
import 'package:chibre_core/src/ai/trump_evaluator.dart';

const _usage = '''
Times a fixed amount of AI work on fixed positions, to compare the speed of
the AI before and after a change. Also prints a fingerprint of the decisions
taken: a change that only makes the AI faster must keep it identical.

Usage: dart run bin/speed_bench.dart [--repeat <n>]
''';

/// Search iterations per card play position.
const _iterations = 5000;
const _trumpSamples = 1000;
const _moveSamples = 300;

void main(List<String> args) {
  var repeat = 5;
  if (args.length == 2 && args[0] == '--repeat') {
    repeat = int.parse(args[1]);
  } else if (args.isNotEmpty) {
    stdout.write(_usage);
    exit(64);
  }

  final plays = _playPositions();
  final trumps = [for (var seed = 0; seed < 6; seed++) _trumpPosition(seed)];
  stdout.writeln('${plays.length} card play positions, '
      '${trumps.length} trump positions');

  final benches = {
    'search ($_iterations iterations)': () => [
          for (final view in plays)
            Ismcts(iterations: _iterations, random: Random(1))
                .search(view)
                .toString(),
        ],
    'trump choice ($_trumpSamples samples)': () => [
          for (final view in trumps)
            TrumpEvaluator(samples: _trumpSamples, random: Random(1))
                .evaluate(view)
                .values
                .map((value) => value.toStringAsFixed(6))
                .join(','),
        ],
    'insights ($_moveSamples samples)': () => [
          for (final view in plays)
            MoveEvaluator(samples: _moveSamples, random: Random(1))
                .evaluate(view)
                .values
                .map((value) => value.toStringAsFixed(6))
                .join(','),
        ],
  };

  var totalMs = 0.0;
  for (final MapEntry(key: name, value: run) in benches.entries) {
    final fingerprint = run().join(' ').hashCode; // Also warms up.
    final times = <int>[];
    for (var i = 0; i < repeat; i++) {
      final stopwatch = Stopwatch()..start();
      run();
      times.add(stopwatch.elapsedMicroseconds);
    }
    times.sort();
    final medianMs = times[times.length ~/ 2] / 1000;
    totalMs += medianMs;
    final perPosition = name.startsWith('trump')
        ? medianMs / trumps.length
        : medianMs / plays.length;
    stdout.writeln('${name.padRight(32)} ${_ms(medianMs)} '
        '(${_ms(perPosition)} per position), '
        'fingerprint ${fingerprint.toRadixString(16)}');
  }
  stdout.writeln('${'total'.padRight(32)} ${_ms(totalMs)}');
}

String _ms(double ms) => '${ms.toStringAsFixed(1)} ms';

/// Positions from early, middle and late tricks in every trump mode, played
/// by heuristic players from seeded deals.
List<PlayerView> _playPositions() {
  final views = <PlayerView>[];
  var seed = 0;
  for (final mode in TrumpMode.values) {
    for (final cardsPlayed in [0, 2, 9, 15, 22]) {
      final round = RoundState(
          options: const GameOptions(obenUndeAllowed: true),
          deal: RandomDealSource(Random(seed++)).nextDeal(),
          trumpChooser: 0)
        ..apply(ChooseTrump(0, mode));
      final heuristic = HeuristicPlayer();
      for (var i = 0; i < cardsPlayed; i++) {
        final seat = round.seatToAct;
        round.apply(heuristic.decide(PlayerView.ofRound(round, seat)));
      }
      views.add(PlayerView.ofRound(round, round.seatToAct));
    }
  }
  return views;
}

PlayerView _trumpPosition(int seed) {
  final round = RoundState(
      options: const GameOptions(obenUndeAllowed: true),
      deal: RandomDealSource(Random(100 + seed)).nextDeal(),
      trumpChooser: seed % seatCount);
  return PlayerView.ofRound(round, round.seatToAct);
}
