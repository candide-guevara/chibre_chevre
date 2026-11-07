/// Pauses that let the humans follow what the computer players do.
class SessionTiming {
  const SessionTiming({
    this.botDelay = const Duration(milliseconds: 600),
    this.trickSlide = const Duration(milliseconds: 400),
    this.roundSummary = const Duration(seconds: 4),
  });

  /// No waiting at all, for tests.
  static const instant = SessionTiming(
    botDelay: Duration.zero,
    trickSlide: Duration.zero,
    roundSummary: Duration.zero,
  );

  /// Minimum time a computer player takes to act.
  final Duration botDelay;

  /// How long a complete trick takes to slide to its winner, after the
  /// host's chosen hold and before a computer player leads the next one.
  final Duration trickSlide;

  /// How long the round summary is shown before the next deal.
  final Duration roundSummary;
}
