import 'dart:math';

import 'card_set.dart';
import 'deal.dart';
import 'deal_source.dart';
import 'seat.dart';

/// Deals the preset cards of each seat in every round, completed at random.
/// Lets testers get given melds without waiting for them.
class PresetHandDealSource implements DealSource {
  PresetHandDealSource(this.presets, [Random? random])
      : assert(presets.values.every((cards) => cards.length <= handSize)),
        _random = random ?? Random();

  /// Cards each seat always gets, by seat; absent seats get random hands.
  final Map<int, CardSet> presets;
  final Random _random;

  @override
  List<CardSet> nextDeal() {
    final preset = presets.values.fold(
      CardSet.empty,
      (all, cards) => all | cards,
    );
    final rest = (CardSet.full - preset).cards..shuffle(_random);
    final hands = <CardSet>[];
    for (var seat = 0; seat < seatCount; seat++) {
      final cards = presets[seat] ?? CardSet.empty;
      final fill = rest.take(handSize - cards.length).toList();
      rest.removeRange(0, fill.length);
      hands.add(cards | CardSet.of(fill));
    }
    return hands;
  }
}
