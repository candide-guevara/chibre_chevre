/// The summary of a round shown to the humans once its last trick slid to
/// its winner. It lasts until every human closed it, or until it times out;
/// the next round waits for it.
class RoundSummaryPopup {
  final _waitingFor = <int>{};
  DateTime? _endsAt;

  /// The round it was last shown for.
  int? _shownFor;

  /// The seats still reading it.
  List<int> get waitingFor => List.unmodifiable(_waitingFor);

  bool get isActive => _waitingFor.isNotEmpty;

  bool wasShownFor(int roundIndex) => _shownFor == roundIndex;

  /// Time left before it closes by itself.
  Duration get remaining {
    final left = _endsAt!.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  void start(int roundIndex, Iterable<int> seats, Duration duration) {
    _shownFor = roundIndex;
    _waitingFor.addAll(seats);
    _endsAt = DateTime.now().add(duration);
  }

  void dismiss(int seat) => _waitingFor.remove(seat);

  void end() => _waitingFor.clear();
}
