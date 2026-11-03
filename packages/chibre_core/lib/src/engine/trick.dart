import 'card.dart';
import 'card_values.dart';
import 'seat.dart';
import 'trump_mode.dart';

/// Position in [cards] of the card currently winning the trick.
int winningIndex(List<Card> cards, TrumpMode mode) {
  final led = cards.first.suit;
  var best = 0;
  var bestStrength = trickStrength(cards.first, led, mode);
  for (var i = 1; i < cards.length; i++) {
    final strength = trickStrength(cards[i], led, mode);
    if (strength > bestStrength) {
      best = i;
      bestStrength = strength;
    }
  }
  return best;
}

/// The cards played so far in a trick, starting with the [leader]'s card.
class Trick {
  Trick(this.leader, [List<Card>? cards]) : cards = cards ?? [];

  final int leader;
  final List<Card> cards;

  bool get isEmpty => cards.isEmpty;

  bool get isComplete => cards.length == seatCount;

  Suit? get ledSuit => cards.isEmpty ? null : cards.first.suit;

  /// The seat that played (or will play) the card at [position].
  int seatAt(int position) => (leader + position) % seatCount;

  int get nextSeat => seatAt(cards.length);

  /// The card played by [seat], or null if it did not play yet.
  Card? cardOf(int seat) {
    final position = (seat - leader) % seatCount;
    return position < cards.length ? cards[position] : null;
  }

  int winner(TrumpMode mode) => seatAt(winningIndex(cards, mode));

  int points(TrumpMode mode) => pointsOf(cards, mode);

  Trick copy() => Trick(leader, List.of(cards));

  @override
  String toString() => 'Trick(leader: $leader, $cards)';
}
