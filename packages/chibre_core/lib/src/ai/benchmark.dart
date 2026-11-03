import 'dart:math';

import '../engine/game_action.dart';
import '../engine/game_options.dart';
import '../engine/random_deal_source.dart';
import '../engine/round_state.dart';
import '../engine/trump_mode.dart';
import '../engine/player_view.dart';
import 'ismcts.dart';

/// Measures how many search iterations this device runs per second, on a
/// fixed position so results are comparable between phones.
double measurePlayoutsPerSecond(
    {Duration duration = const Duration(milliseconds: 300)}) {
  final deal = RandomDealSource(Random(42)).nextDeal();
  final round =
      RoundState(options: const GameOptions(), deal: deal, trumpChooser: 0)
        ..apply(const ChooseTrump(0, TrumpMode.hearts));
  final view = PlayerView.ofRound(round, 0);

  var iterations = 64;
  while (true) {
    final stopwatch = Stopwatch()..start();
    Ismcts(iterations: iterations, random: Random(1)).search(view);
    final elapsed = stopwatch.elapsedMicroseconds;
    if (elapsed >= duration.inMicroseconds || iterations >= 1 << 20) {
      return iterations / elapsed * 1e6;
    }
    iterations *= 2;
  }
}
