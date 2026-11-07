import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:test/test.dart';

void main() {
  test('a seeded runner makes the same move in the same position', () async {
    final game = GameState(
      options: const GameOptions(),
      deals: RandomDealSource(Random(3)),
    );
    game.apply(ChooseTrump(game.seatToAct, TrumpMode.hearts));
    final view = game.viewFor(game.seatToAct);
    const runner = IsolateBotRunner(
      budget: ComputeBudget(
        searchIterations: 300,
        trumpSamples: 30,
        analysisSamples: 20,
      ),
      seed: 0,
    );
    final moves = [for (var i = 0; i < 5; i++) await runner.decide(view)];
    // Cards copied back from an isolate are not identical: compare names.
    final cards = moves.map((move) => '${(move as PlayCard).card}').toSet();
    expect(cards, hasLength(1));
  });
}
