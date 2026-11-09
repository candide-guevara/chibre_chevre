import 'dart:math';

import '../engine/game_action.dart';
import '../engine/game_options.dart';
import '../engine/random_deal_source.dart';
import '../engine/round_state.dart';
import '../engine/trump_mode.dart';
import '../engine/player_view.dart';
import 'ismcts.dart';

/// Measures how many search iterations this device runs per second, on a
/// fixed position so results are comparable between phones. A short search
/// gives a first estimate, then one search sized to last [duration] gives
/// the result.
double measurePlayoutsPerSecond(
    {Duration duration = const Duration(milliseconds: 100)}) {
  final deal = RandomDealSource(Random(42)).nextDeal();
  final round =
      RoundState(options: const GameOptions(), deal: deal, trumpChooser: 0)
        ..apply(const ChooseTrump(0, TrumpMode.hearts));
  final view = PlayerView.ofRound(round, 0);

  double search(int iterations) {
    final stopwatch = Stopwatch()..start();
    Ismcts(iterations: iterations, random: Random(1)).search(view);
    return iterations / max(stopwatch.elapsedMicroseconds, 1) * 1e6;
  }

  final estimate = search(64);
  return search(max(64, (estimate * duration.inMicroseconds / 1e6).round()));
}
