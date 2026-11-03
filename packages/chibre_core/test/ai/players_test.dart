import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_core/src/ai/trump_evaluator.dart';
import 'package:test/test.dart';

import '../helpers.dart';

const smallBudget =
    ComputeBudget(searchIterations: 200, trumpSamples: 40, analysisSamples: 20);

/// Average points per round of [a] and [b], each deal being played twice
/// with the teams swapped to cancel out the luck of the cards.
List<double> duplicate(ComputerPlayer a, ComputerPlayer b, int deals,
    {int seed = 1}) {
  final random = Random(seed);
  final totals = [0, 0];
  for (var i = 0; i < deals; i++) {
    final deal = randomDeal(random);
    final chooser = random.nextInt(seatCount);
    final first =
        MatchRunner([a, b, a, b]).playRound(deal, trumpChooser: chooser);
    final second =
        MatchRunner([b, a, b, a]).playRound(deal, trumpChooser: chooser);
    totals[0] += first.points[0] + second.points[1];
    totals[1] += first.points[1] + second.points[0];
  }
  return [totals[0] / (2 * deals), totals[1] / (2 * deals)];
}

void main() {
  test('all players play complete legal games', () {
    final random = Random(1);
    final players = <ComputerPlayer>[
      ExpertPlayer(budget: smallBudget, random: random),
      RandomPlayer(random),
      HeuristicPlayer(),
      RandomPlayer(random),
    ];
    const options = GameOptions(
        targetScore: 500, obenUndeAllowed: true, multipliersEnabled: true);
    final game = MatchRunner(players, options: options)
        .playGame(deals: RandomDealSource(random));
    expect(game.phase, GamePhase.gameOver);
  });

  test('computer players announce melds and stöck', () {
    final round = RoundState(
        options: const GameOptions(),
        deal: dealOf({0: 'S6 S7 S8 S9 S10 SJ SQ SK SA'}),
        trumpChooser: 0)
      ..apply(const ChooseTrump(0, TrumpMode.spades));
    final players = List.generate(4, (_) => HeuristicPlayer());
    final first = players[0].decidePlay(PlayerView.ofRound(round, 0));
    expect(first.melds.single.value, 300);
    while (round.phase == RoundPhase.playing) {
      final seat = round.seatToAct;
      round.apply(players[seat].decide(PlayerView.ofRound(round, seat)));
    }
    expect(round.stoeckSeat, 0);
  });

  test('the expert values a strong trump suit', () {
    final round = RoundState(
        options: const GameOptions(),
        deal: dealOf({0: 'H6 HJ H9 HA HK HQ H10 SA DA'}),
        trumpChooser: 0);
    final values = TrumpEvaluator(samples: 50, random: Random(1))
        .evaluate(PlayerView.ofRound(round, 0));
    final best = values.entries.reduce((a, b) => b.value > a.value ? b : a);
    expect(best.key, const TrumpOption.mode(TrumpMode.hearts));
  });

  test('the expert passes a hopeless hand to its partner', () {
    final round = RoundState(
        options: const GameOptions(),
        deal: dealOf({0: 'D6 D8 H6 H7 S6 S8 C6 C7 C8'}),
        trumpChooser: 0);
    final action = ExpertPlayer(budget: smallBudget, random: Random(1))
        .decideTrump(PlayerView.ofRound(round, 0));
    expect(action, isA<Chibrer>());
  });

  test('the expert beats random players by a wide margin', () {
    final points = duplicate(
        ExpertPlayer(budget: smallBudget, random: Random(2)),
        RandomPlayer(Random(3)),
        10);
    expect(points[0] - points[1], greaterThan(40));
  });

  test('the expert beats the heuristic player', () {
    final points = duplicate(
        ExpertPlayer(budget: smallBudget, random: Random(4)),
        HeuristicPlayer(),
        30);
    expect(points[0], greaterThan(points[1]));
  });
}
