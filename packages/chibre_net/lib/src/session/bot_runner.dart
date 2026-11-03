import 'package:chibre_core/chibre_core.dart';

/// Runs the expert computer player for the host session. Implementations
/// decide where the computation happens (inline, background isolate...).
abstract interface class BotRunner {
  Future<GameAction> decide(PlayerView view);

  /// The biggest blunders of the human seats, see [BlunderCalculator].
  Future<Map<int, List<Blunder>>> analyse(GameRecord record);
}
