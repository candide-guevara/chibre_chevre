import 'card.dart';

/// What was chosen as trump for a round.
enum TrumpMode {
  diamonds(Suit.diamonds),
  hearts(Suit.hearts),
  spades(Suit.spades),
  clubs(Suit.clubs),

  /// No trump, aces are the highest cards.
  obenabe(null),

  /// No trump, sixes are the highest cards.
  undenufe(null);

  const TrumpMode(this.trumpSuit);

  /// The trump suit, or null for [obenabe] and [undenufe].
  final Suit? trumpSuit;

  static const suits = [diamonds, hearts, spades, clubs];

  static TrumpMode ofSuit(Suit suit) => suits[suit.index];
}
