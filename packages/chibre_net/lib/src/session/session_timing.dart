/// The pace of the game: the pauses and animations that let the humans
/// follow what happens on the table. The host's chosen pause before
/// collecting a trick and the computer players' thinking time are game
/// settings, see `HostConfig`.
class SessionTiming {
  const SessionTiming({
    this.botPause = const Duration(milliseconds: 300),
    this.cardSlide = const Duration(milliseconds: 400),
    this.trickSlide = const Duration(milliseconds: 400),
    this.popup = const Duration(seconds: 10),
    this.selection = const Duration(milliseconds: 120),
    this.turnBadge = const Duration(milliseconds: 400),
  });

  /// No waiting at all, for tests.
  static const instant = SessionTiming(
    botPause: Duration.zero,
    cardSlide: Duration.zero,
    trickSlide: Duration.zero,
    popup: Duration.zero,
    selection: Duration.zero,
    turnBadge: Duration.zero,
  );

  /// The bot pause: once the table is still (the previous card is in place,
  /// the last trick has left the table, a popup was closed...), the time
  /// before a computer player acts. Its search, started as soon as it is
  /// its turn, runs meanwhile: when it takes longer, the computer player
  /// acts as soon as it is done.
  final Duration botPause;

  /// How long a played card takes to slide to its place in the trick.
  final Duration cardSlide;

  /// How long a complete trick takes to slide to its winner, after the
  /// host's chosen pause.
  final Duration trickSlide;

  /// How long the recap of the announcements and the round summary stay at
  /// most, if the humans don't close them.
  final Duration popup;

  /// How long a card of the hand takes to rise when selected.
  final Duration selection;

  /// How long a player's name takes to change color when their turn comes.
  final Duration turnBadge;

  /// How long a complete trick takes to leave the table: its last card
  /// slides in, the trick stays for [hold], then slides to its winner.
  Duration trickOnTable(Duration hold) => cardSlide + hold + trickSlide;
}
