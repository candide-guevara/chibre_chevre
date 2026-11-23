import 'package:chibre_core/chibre_core.dart';

/// Tracks which humans are still choosing their melds at the start of a
/// round; the computer players wait for them before playing.
class MeldChoice {
  final _done = <int>{};
  RoundState? _round;

  /// [seat] chose its melds in [round], or not to announce any.
  void choose(RoundState round, int seat) {
    _follow(round);
    _done.add(seat);
  }

  /// Forgets the choices of the previous round once [round] starts.
  void _follow(RoundState round) {
    if (identical(round, _round)) return;
    _round = round;
    _done.clear();
  }

  /// Among [humans], the seats still choosing in [round]: from the trump
  /// choice until they decide or play their first card.
  List<int> pending(RoundState round, Iterable<int> humans) {
    _follow(round);
    if (!round.options.meldsEnabled ||
        round.mode == null ||
        round.completedTricks.isNotEmpty) {
      return const [];
    }
    return [
      for (final seat in humans)
        if (!_done.contains(seat) &&
            round.handOf(seat).length == handSize &&
            round.meldsOf(seat).isEmpty)
          seat,
    ];
  }
}
