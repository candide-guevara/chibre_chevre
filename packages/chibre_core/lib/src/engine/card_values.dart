import 'card.dart';
import 'card_set.dart';
import 'trump_mode.dart';

const lastTrickBonus = 5;
const matchBonus = 100;

/// Card points of a round, last trick bonus included.
const roundPoints = 157;

// Lists below are indexed by Rank.index: 6, 7, 8, 9, 10, J, Q, K, A.
const _plainPoints = [0, 0, 0, 0, 10, 2, 3, 4, 11];
const _trumpPoints = [0, 0, 0, 14, 10, 20, 3, 4, 11];
const _obenabePoints = [0, 0, 8, 0, 10, 2, 3, 4, 11];
const _undenufePoints = [11, 0, 8, 0, 10, 2, 3, 4, 0];
const _trumpOrder = [0, 1, 2, 7, 3, 8, 4, 5, 6];

int cardPoints(Card card, TrumpMode mode) => switch (mode) {
      TrumpMode.obenabe => _obenabePoints[card.rank.index],
      TrumpMode.undenufe => _undenufePoints[card.rank.index],
      _ when card.suit == mode.trumpSuit => _trumpPoints[card.rank.index],
      _ => _plainPoints[card.rank.index],
    };

int pointsOf(Iterable<Card> cards, TrumpMode mode) =>
    cards.fold(0, (sum, card) => sum + cardPoints(card, mode));

/// Strength of a card compared to cards of the same suit: higher wins.
int suitStrength(Card card, TrumpMode mode) => switch (mode) {
      TrumpMode.undenufe => Rank.values.length - 1 - card.rank.index,
      _ when card.suit == mode.trumpSuit => _trumpOrder[card.rank.index],
      _ => card.rank.index,
    };

/// Strength of a card in a trick led with [led]: trumps beat everything,
/// cards that neither follow nor trump can't win (-1).
int trickStrength(Card card, Suit led, TrumpMode mode) {
  if (card.suit == mode.trumpSuit) return 100 + suitStrength(card, mode);
  if (card.suit == led) return suitStrength(card, mode);
  return -1;
}

/// The cards of [cards] that are stronger than [card] in its own suit.
CardSet strongerInSuit(Card card, CardSet cards, TrumpMode mode) {
  final strength = suitStrength(card, mode);
  return CardSet.of(cards
      .ofSuit(card.suit)
      .cards
      .where((other) => suitStrength(other, mode) > strength));
}
