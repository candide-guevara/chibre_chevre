/// The four Swiss-French suits.
enum Suit {
  diamonds('D', '♦'),
  hearts('H', '♥'),
  spades('S', '♠'),
  clubs('C', '♣');

  const Suit(this.letter, this.symbol);

  final String letter;
  final String symbol;
}

/// Ranks in their natural order, from six to ace.
enum Rank {
  six('6'),
  seven('7'),
  eight('8'),
  nine('9'),
  ten('10'),
  jack('J'),
  queen('Q'),
  king('K'),
  ace('A');

  const Rank(this.label);

  final String label;
}

/// A playing card. There is exactly one instance per card, so cards can be
/// compared with `==` and used as map keys.
final class Card {
  Card._(this.suit, this.rank)
      : index = suit.index * Rank.values.length + rank.index;

  factory Card(Suit suit, Rank rank) =>
      all[suit.index * Rank.values.length + rank.index];

  factory Card.fromIndex(int index) => all[index];

  /// Parses the notation produced by [toString], e.g. `D7`, `HJ` or `S10`.
  factory Card.parse(String text) {
    final suit = Suit.values.firstWhere(
      (s) => text.startsWith(s.letter),
      orElse: () => throw FormatException('Unknown suit', text),
    );
    final rank = Rank.values.firstWhere(
      (r) => r.label == text.substring(1),
      orElse: () => throw FormatException('Unknown rank', text),
    );
    return Card(suit, rank);
  }

  static const count = 36;

  static final List<Card> all = List.unmodifiable([
    for (final suit in Suit.values)
      for (final rank in Rank.values) Card._(suit, rank),
  ]);

  final Suit suit;
  final Rank rank;

  /// Position of the card in [all], from 0 to 35.
  final int index;

  @override
  String toString() => '${suit.letter}${rank.label}';
}
