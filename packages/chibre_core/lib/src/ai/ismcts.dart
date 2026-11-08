import 'dart:math';

import '../engine/card.dart';
import '../engine/card_values.dart';
import '../engine/player_view.dart';
import '../engine/seat.dart';
import 'heuristic_policy.dart';
import 'playout.dart';
import 'world_sampler.dart';

/// Information Set Monte Carlo Tree Search (single observer).
///
/// Each iteration deals the unseen cards at random (consistently with what
/// the player observed), walks down a tree shared by all those deals,
/// finishes the round with the heuristic policy and backs the result up.
class Ismcts {
  Ismcts({
    required this.iterations,
    this.timeLimit,
    this.exploration = 0.7,
    this.rolloutRandomness = 0.1,
    Random? random,
  }) : _random = random ?? Random();

  final int iterations;

  /// Stops early when exceeded, to keep the game snappy on slow phones.
  final Duration? timeLimit;
  final double exploration;

  /// Probability of playing a random legal card during rollouts.
  final double rolloutRandomness;
  final Random _random;

  Card search(PlayerView view) {
    final sampler = WorldSampler(view);
    final root = _Node(null, view.seat);
    final start = Playout.fromView(view, sampler.hands);
    final stopwatch = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      if (i > 0 && i % 32 == 0 && _timeIsUp(stopwatch)) {
        break;
      }
      _iterate(root, start.withHands(sampler.sample(_random)));
    }
    var best = root.children.first;
    for (final child in root.children) {
      if (child.visits > best.visits) best = child;
    }
    return best.card!;
  }

  bool _timeIsUp(Stopwatch stopwatch) =>
      timeLimit != null && stopwatch.elapsed > timeLimit!;

  void _iterate(_Node root, Playout world) {
    final path = <_Node>[];
    var node = root;
    while (!world.isOver) {
      final legal = world.legalCards;
      var untried = legal;
      for (final child in node.children) {
        if (legal.contains(child.card!)) {
          child.availability++;
          untried = untried.remove(child.card!);
        }
      }
      if (untried.isNotEmpty) {
        final options = untried.cards;
        final child =
            _Node(options[_random.nextInt(options.length)], world.seatToAct);
        node.children.add(child);
        world.play(child.card!);
        path.add(child);
        break;
      }
      node = _select(node, world);
      world.play(node.card!);
      path.add(node);
    }

    while (!world.isOver) {
      world.play(_rolloutCard(world));
    }
    for (final visited in path) {
      visited.visits++;
      visited.reward += _reward(world, teamOf(visited.seat));
    }
  }

  _Node _select(_Node node, Playout world) {
    final legal = world.legalCards;
    _Node? best;
    var bestScore = double.negativeInfinity;
    for (final child in node.children) {
      if (!legal.contains(child.card!)) continue;
      final score = child.reward / child.visits +
          exploration * sqrt(log(child.availability) / child.visits);
      if (score > bestScore) {
        best = child;
        bestScore = score;
      }
    }
    return best!;
  }

  Card _rolloutCard(Playout world) {
    if (_random.nextDouble() < rolloutRandomness) {
      final legal = world.legalCards.cards;
      return legal[_random.nextInt(legal.length)];
    }
    final seat = world.seatToAct;
    return heuristicCard(
        world.hands[seat], world.trick, world.mode, world.unplayed);
  }

  /// The advantage of [team], scaled to [0, 1].
  double _reward(Playout world, int team) =>
      (world.advantage(team) * 2 + roundPoints + matchBonus) /
      (2 * (roundPoints + matchBonus));
}

class _Node {
  _Node(this.card, this.seat);

  /// The card played to reach this node, null for the root.
  final Card? card;

  /// The seat that played [card].
  final int seat;
  final children = <_Node>[];
  var visits = 0;
  var availability = 0;
  var reward = 0.0;
}
