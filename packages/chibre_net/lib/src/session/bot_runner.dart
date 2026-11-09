import 'package:chibre_core/chibre_core.dart';

/// Runs the expert computer player for the host session. Implementations
/// decide where the computation happens (inline, background isolate...).
abstract interface class BotRunner {
  Future<GameAction> decide(PlayerView view);

  /// The biggest blunders of [seats] in the round [roundIndex] of
  /// [record], or null once [timeLimit] is exceeded; see
  /// [BlunderCalculator.analyseRound].
  Future<Map<int, List<Blunder>>?> analyseRound(
      GameRecord record, int roundIndex,
      {Set<int> seats = const {0, 2}, Duration? timeLimit});
}
