import 'trump_mode.dart';

/// Options chosen by the host when creating a game.
class GameOptions {
  const GameOptions({
    this.targetScore = 1000,
    this.obenUndeAllowed = false,
    this.multipliersEnabled = false,
    this.finishLastRound = false,
  });

  final int targetScore;

  /// Whether obenabe and undenufe may be chosen in addition to the 4 suits.
  final bool obenUndeAllowed;

  final bool multipliersEnabled;

  /// Whether the round in which a team reaches [targetScore] is played to
  /// the end rather than stopped. The first team to reach it still wins.
  final bool finishLastRound;

  List<TrumpMode> get allowedModes =>
      obenUndeAllowed ? TrumpMode.values : TrumpMode.suits;

  int multiplierFor(TrumpMode mode) {
    if (!multipliersEnabled) return 1;
    return switch (mode) {
      TrumpMode.diamonds || TrumpMode.hearts => 1,
      TrumpMode.spades || TrumpMode.clubs => 2,
      TrumpMode.obenabe || TrumpMode.undenufe => 3,
    };
  }
}
