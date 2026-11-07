import 'package:chibre_core/chibre_core.dart';

/// Suits alternate colours so neighbours are easy to tell apart.
const _suitOrder = [Suit.hearts, Suit.spades, Suit.diamonds, Suit.clubs];

/// [hand] sorted for display, suit by suit in the order ♥ ♠ ♦ ♣, each suit
/// from six to ace. With [byTrump], once trump is chosen, trump comes first
/// and each suit goes from weakest to strongest in the round's [mode].
List<Card> sortHand(CardSet hand, TrumpMode? mode, {required bool byTrump}) {
  final trumpOrder = byTrump ? mode : null;
  int suitRank(Suit suit) =>
      suit == trumpOrder?.trumpSuit ? -1 : _suitOrder.indexOf(suit);
  int strength(Card card) =>
      trumpOrder == null ? card.rank.index : suitStrength(card, trumpOrder);
  return hand.cards..sort((a, b) {
    final bySuit = suitRank(a.suit) - suitRank(b.suit);
    return bySuit != 0 ? bySuit : strength(a) - strength(b);
  });
}
