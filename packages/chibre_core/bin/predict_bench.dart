import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_core/src/ai/ismcts.dart';
import 'package:chibre_core/src/ai/move_evaluator.dart';

const _usage = '''
Measures how well cheap predictors guess the card an expert plays, so that
the computer player who plays next can start thinking about its reply
before the human has played.

Usage:
  dart run bin/predict_bench.dart record <file> [--games <n>] [--thinking <s>]
      Expert teams play whole games, thinking as long as [--thinking]
      seconds (default 0.6) on this machine, counted in iterations. The
      games are saved to <file>.
  dart run bin/predict_bench.dart evaluate <file>
      Replays the card plays of the saved games and compares each
      predictor's guess with the card the expert played.
  dart run bin/predict_bench.dart ceiling <file> --iterations <n>
        [--positions <n>]
      How often the expert itself, searching again with another seed,
      plays the same card: the best rate a predictor can hope for.
''';

Future<void> main(List<String> args) async {
  if (args.length < 2) return _fail();
  final options = <String, String>{};
  for (var i = 2; i + 1 < args.length; i += 2) {
    options[args[i].replaceFirst('--', '')] = args[i + 1];
  }
  switch (args[0]) {
    case 'record':
      await _record(File(args[1]), int.parse(options['games'] ?? '28'),
          double.parse(options['thinking'] ?? '0.6'));
    case 'evaluate':
      _evaluate(File(args[1]));
    case 'ceiling':
      await _ceiling(File(args[1]), int.parse(options['iterations']!),
          int.parse(options['positions'] ?? '300'));
    default:
      _fail();
  }
}

void _fail() {
  stdout.write(_usage);
  exit(64);
}

// -------------------------------------------------------------- Recording

Future<void> _record(File file, int games, double thinking) async {
  final speed = measurePlayoutsPerSecond();
  final iterations = (speed * thinking).round();
  stdout.writeln('${speed.round()} iterations/s: $iterations search '
      'iterations, ${iterations ~/ 7} trump samples per decision');

  final stopwatch = Stopwatch()..start();
  final lines = <String>[];
  var next = 0;
  var done = 0;
  Future<void> worker() async {
    while (next < games) {
      final seed = next++;
      lines.add(await Isolate.run(() => _playGame(seed, iterations)));
      stdout.write('\r${++done}/$games games '
          '(${stopwatch.elapsed.inMinutes} min)');
    }
  }

  await Future.wait(
      [for (var i = 0; i < Platform.numberOfProcessors - 1; i++) worker()]);
  stdout.writeln();
  file.writeAsStringSync('${lines.join('\n')}\n');
}

/// One game, one line: each round's chooser, deal and actions.
String _playGame(int seed, int iterations) {
  final budget = ComputeBudget(
      searchIterations: iterations,
      trumpSamples: iterations ~/ 7,
      analysisSamples: 0);
  final player = ExpertPlayer(budget: budget, random: Random(seed));
  final game = MatchRunner(List.filled(seatCount, player))
      .playGame(deals: RandomDealSource(Random(seed)));
  return [
    for (final round in game.record.rounds)
      [
        'R${round.trumpChooser}',
        for (final hand in round.deal) hand.bits,
        for (final action in round.actions) _encode(action),
      ].join(' '),
  ].join(' | ');
}

String _encode(GameAction action) => switch (action) {
      ChooseTrump(:final seat, :final mode) => 'T$seat.${mode.index}',
      Chibrer(:final seat) => 'C$seat',
      PlayCard(:final seat, :final card, :final melds, :final stoeck) =>
        'P$seat.${card.index}.${melds.isEmpty ? 0 : 1}.${stoeck ? 1 : 0}',
    };

// ------------------------------------------------------------- Evaluation

/// A decision to predict: the player's view and the card the expert played.
typedef _Position = ({PlayerView view, Card played});

void _evaluate(File file) {
  final positions = _replay(file);
  final lastToPlay =
      positions.where((p) => p.view.currentTrick!.cards.length == 3).length;
  stdout.writeln('${positions.length} card plays with a choice, '
      '${positions.length - lastToPlay} of them not last in the trick');
  for (final MapEntry(key: name, value: predict) in _predictors.entries) {
    _report(name, predict, positions);
  }
}

/// Spread over the games, in parallel.
Future<void> _ceiling(File file, int iterations, int count) async {
  final positions = _replay(file);
  final step = positions.length / count;
  final picked = [
    for (var i = 0; i < count; i++) positions[(i * step).floor()]
  ];
  final workers = Platform.numberOfProcessors - 1;
  final agreements = await Future.wait([
    for (var w = 0; w < workers; w++)
      Isolate.run(() {
        var same = 0;
        for (var i = w; i < picked.length; i += workers) {
          final card = Ismcts(iterations: iterations, random: Random(1000 + i))
              .search(picked[i].view);
          if (card == picked[i].played) same++;
        }
        return same;
      }),
  ]);
  final same = agreements.reduce((a, b) => a + b);
  stdout.writeln('the expert plays the same card again in $same/$count '
      'positions (${(same / count * 100).toStringAsFixed(1)}%)');
}

List<_Position> _replay(File file) {
  final positions = <_Position>[];
  for (final line in file.readAsLinesSync().where((l) => l.isNotEmpty)) {
    final record = GameRecord(const GameOptions());
    final rounds = line.split(' | ').map((r) => r.split(' ')).toList();
    for (final fields in rounds) {
      record.rounds.add(RoundRecord(deal: [
        for (final bits in fields.sublist(1, 5)) CardSet(int.parse(bits))
      ], trumpChooser: int.parse(fields[0].substring(1))));
    }
    final game = GameState.replaying(record);
    for (final (index, fields) in rounds.indexed) {
      if (index > 0) game.startNextRound();
      for (final token in fields.sublist(5)) {
        final action = _decode(token, game);
        if (action is PlayCard) {
          final view = game.viewFor(action.seat);
          if (view.legalCards.length > 1) {
            positions.add((view: view, played: action.card));
          }
        }
        game.apply(action);
      }
    }
  }
  return positions;
}

GameAction _decode(String token, GameState game) {
  final parts = token.substring(1).split('.').map(int.parse).toList();
  final seat = parts[0];
  return switch (token[0]) {
    'T' => ChooseTrump(seat, TrumpMode.values[parts[1]]),
    'C' => Chibrer(seat),
    _ => PlayCard(seat, Card.fromIndex(parts[1]),
        melds:
            parts[2] == 1 ? findBestMelds(game.viewFor(seat).hand) : const [],
        stoeck: parts[3] == 1),
  };
}

/// Each predictor ranks the legal cards, most likely first.
typedef _Predictor = List<Card> Function(PlayerView view);

/// The best candidates found, see the git history for the others tried.
final Map<String, _Predictor> _predictors = {
  'rollout policy': (view) => [
        heuristicCard(view.hand, view.currentTrick!.cards, view.mode!,
            CardSet.full - view.playedCards),
      ],
  'evaluator 80': (view) =>
      _byValue(MoveEvaluator(samples: 80, random: Random(1)).evaluate(view)),
  for (final iterations in [800, 1600])
    'search $iterations c0.3': (view) =>
        Ismcts(iterations: iterations, exploration: 0.3, random: Random(1))
            .rank(view),
};

List<Card> _byValue(Map<Card, double> values) =>
    values.keys.toList()..sort((a, b) => values[b]!.compareTo(values[a]!));

void _report(String name, _Predictor predict, List<_Position> positions) {
  // Warms up, then times every prediction.
  for (final position in positions.take(50)) {
    predict(position.view);
  }
  final times = <int>[];
  var first = 0;
  var equivalent = 0;
  var top2 = 0;
  var useful = 0;
  var usefulFirst = 0;
  for (final position in positions) {
    final stopwatch = Stopwatch()..start();
    final ranking = predict(position.view);
    times.add(stopwatch.elapsedMicroseconds);
    final hit = ranking.first == position.played;
    if (hit) first++;
    if (_equivalent(ranking.first, position.played, position.view)) {
      equivalent++;
    }
    if (ranking.take(2).contains(position.played)) top2++;
    if (position.view.currentTrick!.cards.length < 3) {
      useful++;
      if (hit) usefulFirst++;
    }
  }
  times.sort();
  String percent(int count, int total) =>
      '${(count / total * 100).toStringAsFixed(1)}%';
  stdout.writeln('${name.padRight(24)} median '
      '${(times[times.length ~/ 2] / 1000).toStringAsFixed(2)} ms, '
      'max ${(times.last / 1000).toStringAsFixed(1)} ms: '
      'right ${percent(first, positions.length)} '
      '(${percent(usefulFirst, useful)} when not last), '
      'equivalent ${percent(equivalent, positions.length)}, '
      'top 2 ${percent(top2, positions.length)}');
}

/// The same card, or cards of the same suit and points with no card that
/// someone else may still play, nor a card of the current trick, between
/// them: e.g. the 6 and 7 once the 8 is gone.
bool _equivalent(Card a, Card b, PlayerView view) {
  if (a == b) return true;
  final mode = view.mode!;
  if (a.suit != b.suit || cardPoints(a, mode) != cardPoints(b, mode)) {
    return false;
  }
  final trick = CardSet.of(view.currentTrick!.cards);
  final separators = (CardSet.full - view.playedCards - view.hand) | trick;
  final (low, high) =
      suitStrength(a, mode) < suitStrength(b, mode) ? (a, b) : (b, a);
  return (strongerInSuit(low, separators, mode) -
          strongerInSuit(high, separators, mode) -
          CardSet.of([high]))
      .isEmpty;
}
