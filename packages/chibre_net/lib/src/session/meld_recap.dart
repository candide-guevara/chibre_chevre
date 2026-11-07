import 'package:chibre_core/chibre_core.dart';

/// The recap of the meld calls shown to the humans once the first trick has
/// been collected. It lasts until every human closed it, or until it times
/// out; nobody plays meanwhile.
class MeldRecap {
  final _waitingFor = <int>{};
  DateTime? _endsAt;
  var _shown = false;

  /// The seats still reading it.
  List<int> get waitingFor => List.unmodifiable(_waitingFor);

  bool get isActive => _waitingFor.isNotEmpty;

  /// Whether it was shown during this round's first trick break.
  bool get wasShown => _shown;

  /// Time left before it closes by itself.
  Duration get remaining {
    final left = _endsAt!.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  /// Whether [round] just finished its first trick, with melds to show.
  bool isDue(RoundState round) =>
      !_shown &&
      round.completedTricks.length == 1 &&
      round.currentTrick?.isEmpty == true &&
      [for (var seat = 0; seat < seatCount; seat++) ...round.meldsOf(seat)]
          .isNotEmpty;

  void start(Iterable<int> seats, Duration duration) {
    _shown = true;
    _waitingFor.addAll(seats);
    _endsAt = DateTime.now().add(duration);
  }

  void dismiss(int seat) => _waitingFor.remove(seat);

  void end() => _waitingFor.clear();

  /// Forgets the previous round's recap.
  void reset() {
    _waitingFor.clear();
    _shown = false;
  }
}
