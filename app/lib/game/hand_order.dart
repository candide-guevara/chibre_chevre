import 'package:chibre_core/chibre_core.dart';

/// Suits alternate colours so neighbours are easy to tell apart.
const _suitOrder = [Suit.hearts, Suit.spades, Suit.diamonds, Suit.clubs];

/// [hand] sorted for display: trump first once chosen, then by suit, each
/// suit from weakest to strongest.
List<Card> sortHand(CardSet hand, TrumpMode? mode) {
  int suitRank(Suit suit) =>
      suit == mode?.trumpSuit ? -1 : _suitOrder.indexOf(suit);
  int strength(Card card) =>
      mode == null ? card.rank.index : suitStrength(card, mode);
  return hand.cards..sort((a, b) {
    final bySuit = suitRank(a.suit) - suitRank(b.suit);
    return bySuit != 0 ? bySuit : strength(a) - strength(b);
  });
}
