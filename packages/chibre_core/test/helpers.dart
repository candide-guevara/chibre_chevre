import 'package:chibre_core/chibre_core.dart';

Card c(String text) => Card.parse(text);

CardSet cards(String text) => CardSet.parse(text);

/// Readable form of a card set, for assertions.
String show(CardSet set) => set.cards.join(' ');

/// Cards in the given order, e.g. the cards of a trick.
List<Card> trick(String text) =>
    text.split(' ').where((t) => t.isNotEmpty).map(Card.parse).toList();

/// A deal where the given seats hold the given cards and the remaining cards
/// go, in index order, to the seats left unspecified.
List<CardSet> dealOf(Map<int, String> hands) {
  final deal = List.filled(seatCount, CardSet.empty);
  var remaining = CardSet.full;
  hands.forEach((seat, text) {
    deal[seat] = cards(text);
    remaining = remaining - deal[seat];
  });
  final rest = remaining.cards;
  var next = 0;
  for (var seat = 0; seat < seatCount; seat++) {
    if (hands.containsKey(seat)) continue;
    deal[seat] = CardSet.of(rest.sublist(next, next + handSize));
    next += handSize;
  }
  return deal;
}

/// Plays the first legal card for every seat until the round is over.
void playFirstLegalCards(RoundState round) {
  while (round.phase == RoundPhase.playing) {
    round.apply(PlayCard(round.seatToAct, round.legalCards.cards.first));
  }
}
