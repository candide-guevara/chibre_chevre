import 'dart:math';

import 'card.dart';
import 'card_set.dart';
import 'seat.dart';

const handSize = 9;
const tricksPerRound = 9;

/// Shuffles the deck and deals [handSize] cards to each seat.
List<CardSet> randomDeal(Random random) {
  final deck = List.of(Card.all)..shuffle(random);
  return [
    for (var seat = 0; seat < seatCount; seat++)
      CardSet.of(deck.sublist(seat * handSize, (seat + 1) * handSize)),
  ];
}

/// The seat holding [card] in [deal].
int holderOf(Card card, List<CardSet> deal) =>
    deal.indexWhere((hand) => hand.contains(card));
