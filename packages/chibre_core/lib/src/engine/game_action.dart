import 'card.dart';
import 'meld.dart';
import 'trump_mode.dart';

/// Something a player does during a round.
sealed class GameAction {
  const GameAction(this.seat);

  final int seat;
}

final class ChooseTrump extends GameAction {
  const ChooseTrump(super.seat, this.mode);

  final TrumpMode mode;

  @override
  String toString() => 'ChooseTrump($seat, ${mode.name})';
}

/// Passes the trump choice to the partner.
final class Chibrer extends GameAction {
  const Chibrer(super.seat);

  @override
  String toString() => 'Chibrer($seat)';
}

/// Plays a card, optionally announcing melds (first trick only) and Stöck
/// (when playing the second of the king and queen of trump).
final class PlayCard extends GameAction {
  const PlayCard(super.seat, this.card,
      {this.melds = const [], this.stoeck = false});

  final Card card;
  final List<Meld> melds;
  final bool stoeck;

  @override
  String toString() => 'PlayCard($seat, $card'
      '${melds.isEmpty ? '' : ', melds: $melds'}'
      '${stoeck ? ', stöck' : ''})';
}
