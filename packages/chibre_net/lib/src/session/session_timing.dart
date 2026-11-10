/// Pauses that let the humans follow what the computer players do.
class SessionTiming {
  const SessionTiming({
    this.botDelay = const Duration(milliseconds: 400),
    this.cardSlide = const Duration(milliseconds: 400),
    this.trickSlide = const Duration(milliseconds: 400),
    this.popup = const Duration(seconds: 10),
  });

  /// No waiting at all, for tests.
  static const instant = SessionTiming(
    botDelay: Duration.zero,
    cardSlide: Duration.zero,
    trickSlide: Duration.zero,
    popup: Duration.zero,
  );

  /// Minimum time a computer player takes to act.
  final Duration botDelay;

  /// How long a played card takes to slide to its place in the trick.
  final Duration cardSlide;

  /// How long a complete trick takes to slide to its winner, after the
  /// host's chosen hold and before a computer player leads the next one.
  final Duration trickSlide;

  /// How long a complete trick takes to leave the table: its last card
  /// slides in, the trick stays for [hold], then slides to its winner.
  Duration trickOnTable(Duration hold) => cardSlide + hold + trickSlide;

  /// How long the recap of the announcements and the round summary stay at
  /// most, if the humans don't close them.
  final Duration popup;
}
