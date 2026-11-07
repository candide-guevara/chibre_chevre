import 'package:chibre_core/chibre_core.dart';

/// Tracks which humans are still choosing their melds at the start of a
/// round; the computer players wait for them before playing.
class MeldChoice {
  final _done = <int>{};

  /// A new round starts.
  void reset() => _done.clear();

  /// [seat] chose its melds, or not to announce any.
  void choose(int seat) => _done.add(seat);

  /// Among [humans], the seats still choosing in [round]: from the trump
  /// choice until they decide or play their first card.
  List<int> pending(RoundState round, Iterable<int> humans) {
    if (round.mode == null || round.completedTricks.isNotEmpty) return const [];
    return [
      for (final seat in humans)
        if (!_done.contains(seat) &&
            round.handOf(seat).length == handSize &&
            round.meldsOf(seat).isEmpty)
          seat,
    ];
  }
}
