import 'dart:math';

import 'card_set.dart';
import 'deal.dart';
import 'deal_source.dart';
import 'seat.dart';

/// Deals [cards] to [seat] in every round, completed at random; the other
/// seats get random hands. Lets testers get a given meld without waiting.
class PresetHandDealSource implements DealSource {
  PresetHandDealSource(this.seat, this.cards, [Random? random])
      : assert(cards.length <= handSize),
        _random = random ?? Random();

  final int seat;
  final CardSet cards;
  final Random _random;

  @override
  List<CardSet> nextDeal() {
    final rest = (CardSet.full - cards).cards..shuffle(_random);
    final fill = handSize - cards.length;
    final hands = <CardSet>[];
    var next = fill;
    for (var s = 0; s < seatCount; s++) {
      if (s == seat) {
        hands.add(cards | CardSet.of(rest.sublist(0, fill)));
      } else {
        hands.add(CardSet.of(rest.sublist(next, next + handSize)));
        next += handSize;
      }
    }
    return hands;
  }
}
