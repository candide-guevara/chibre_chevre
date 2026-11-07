import 'package:chibre_core/chibre_core.dart';

/// The recap of the announcements shown to the humans after a trick: the
/// meld calls after the first trick, and Stöck after the trick in which it
/// was announced. It lasts until every human closed it, or until it times
/// out; nobody plays meanwhile.
class AnnouncementRecap {
  final _waitingFor = <int>{};
  DateTime? _endsAt;

  /// The number of completed tricks when it was last shown this round.
  int? _shownAfter;

  /// The seats still reading it.
  List<int> get waitingFor => List.unmodifiable(_waitingFor);

  bool get isActive => _waitingFor.isNotEmpty;

  /// Whether it was shown after the last completed trick of [round].
  bool wasShownAfterLastTrick(RoundState round) =>
      _shownAfter == round.completedTricks.length;

  /// Time left before it closes by itself.
  Duration get remaining {
    final left = _endsAt!.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  /// Whether [round] just finished a trick after which announcements must
  /// be shown.
  bool isDue(RoundState round) =>
      round.currentTrick?.isEmpty == true &&
      !wasShownAfterLastTrick(round) &&
      hasAnnouncementsAfterLastTrick(
        round.completedTricks,
        [for (var seat = 0; seat < seatCount; seat++) round.meldsOf(seat)],
        round.stoeckSeat,
        round.mode!,
      );

  void start(RoundState round, Iterable<int> seats, Duration duration) {
    _shownAfter = round.completedTricks.length;
    _waitingFor.addAll(seats);
    _endsAt = DateTime.now().add(duration);
  }

  void dismiss(int seat) => _waitingFor.remove(seat);

  void end() => _waitingFor.clear();

  /// Forgets the previous round's recap.
  void reset() {
    _waitingFor.clear();
    _shownAfter = null;
  }
}

/// Whether announcements must be shown after the last of [tricks]: melds
/// after the first trick, Stöck after the trick in which it was announced.
bool hasAnnouncementsAfterLastTrick(
  List<Trick> tricks,
  List<List<Meld>> melds,
  int? stoeckSeat,
  TrumpMode mode,
) {
  if (tricks.isEmpty) return false;
  final meldsShown = tricks.length == 1 && melds.any((m) => m.isNotEmpty);
  final stoeckShown =
      stoeckTrickIndex(tricks, stoeckSeat, mode) == tricks.length - 1;
  return meldsShown || stoeckShown;
}
