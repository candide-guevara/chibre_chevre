import 'package:chibre_core/chibre_core.dart';

/// French names of game concepts shown in the UI.

String rankIndex(Rank rank) => switch (rank) {
  Rank.jack => 'V',
  Rank.queen => 'D',
  Rank.king => 'R',
  Rank.ace => 'A',
  _ => rank.label,
};

String rankName(Rank rank) => switch (rank) {
  Rank.jack => 'valet',
  Rank.queen => 'dame',
  Rank.king => 'roi',
  Rank.ace => 'as',
  _ => rank.label,
};

String suitName(Suit suit) => switch (suit) {
  Suit.diamonds => 'carreau',
  Suit.hearts => 'cœur',
  Suit.spades => 'pique',
  Suit.clubs => 'trèfle',
};

String cardName(Card card) =>
    '${rankName(card.rank)} de ${suitName(card.suit)}';

String shortCard(Card card) => '${rankIndex(card.rank)}${card.suit.symbol}';

String modeName(TrumpMode mode) => switch (mode) {
  TrumpMode.obenabe => 'Obenabe',
  TrumpMode.undenufe => 'Undenufe',
  _ => 'Atout ${suitName(mode.trumpSuit!)}',
};

String modeSymbol(TrumpMode mode) => switch (mode) {
  TrumpMode.obenabe => '⬇',
  TrumpMode.undenufe => '⬆',
  _ => mode.trumpSuit!.symbol,
};

String trumpOptionName(TrumpOption option) =>
    option.isChibrer ? 'Chibrer' : modeName(option.mode!);

String meldName(Meld meld) {
  final cards = meld.cards.cards.map(shortCard).join(' ');
  return '${meld.value} ($cards)';
}

String blunderTitle(BlunderKind kind) => switch (kind) {
  BlunderKind.trumpChoice => 'Choix de l\'atout',
  BlunderKind.cardPlay => 'Carte jouée',
  BlunderKind.missedMeld => 'Annonce oubliée',
  BlunderKind.missedStoeck => 'Stöck oublié',
};
