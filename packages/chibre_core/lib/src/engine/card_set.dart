import 'card.dart';

/// An immutable set of cards stored as a 36-bit mask, bit `i` being the card
/// with index `i`. Being a plain int at runtime keeps the search fast.
extension type const CardSet(int bits) {
  static const empty = CardSet(0);
  static const full = CardSet((1 << Card.count) - 1);

  factory CardSet.of(Iterable<Card> cards) {
    var bits = 0;
    for (final card in cards) {
      bits |= 1 << card.index;
    }
    return CardSet(bits);
  }

  factory CardSet.suit(Suit suit) =>
      CardSet(_suitMask << (suit.index * Rank.values.length));

  /// Parses a space separated list of cards, e.g. `D7 HJ S10`.
  factory CardSet.parse(String text) => CardSet.of(
        text.split(' ').where((token) => token.isNotEmpty).map(Card.parse),
      );

  static const _suitMask = 0x1FF;

  bool get isEmpty => bits == 0;

  bool get isNotEmpty => bits != 0;

  int get length {
    var remaining = bits;
    var count = 0;
    while (remaining != 0) {
      remaining &= remaining - 1;
      count++;
    }
    return count;
  }

  bool contains(Card card) => bits & (1 << card.index) != 0;

  bool containsAll(CardSet other) => bits & other.bits == other.bits;

  CardSet add(Card card) => CardSet(bits | (1 << card.index));

  CardSet remove(Card card) => CardSet(bits & ~(1 << card.index));

  CardSet operator |(CardSet other) => CardSet(bits | other.bits);

  CardSet operator &(CardSet other) => CardSet(bits & other.bits);

  CardSet operator -(CardSet other) => CardSet(bits & ~other.bits);

  CardSet ofSuit(Suit suit) => this & CardSet.suit(suit);

  /// The cards in index order: suit by suit, from six to ace.
  List<Card> get cards {
    final result = <Card>[];
    var remaining = bits;
    while (remaining != 0) {
      final lowest = remaining & -remaining;
      result.add(Card.fromIndex(lowest.bitLength - 1));
      remaining ^= lowest;
    }
    return result;
  }
}
