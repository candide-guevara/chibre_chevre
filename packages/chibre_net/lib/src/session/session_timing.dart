/// Pauses that let the humans follow what the computer players do.
class SessionTiming {
  const SessionTiming({
    this.botDelay = const Duration(milliseconds: 600),
    this.trickPause = const Duration(milliseconds: 1200),
    this.roundSummary = const Duration(seconds: 4),
  });

  /// No waiting at all, for tests.
  static const instant = SessionTiming(
    botDelay: Duration.zero,
    trickPause: Duration.zero,
    roundSummary: Duration.zero,
  );

  /// Minimum time a computer player takes to act.
  final Duration botDelay;

  /// How long a complete trick stays on the table before a computer player
  /// leads the next one.
  final Duration trickPause;

  /// How long the round summary is shown before the next deal.
  final Duration roundSummary;
}
