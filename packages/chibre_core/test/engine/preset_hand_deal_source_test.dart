import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

void main() {
  test('preset seats always hold their cards, deals stay valid', () {
    final host = CardSet.parse('D7 D9 DJ DA');
    final partner = CardSet.parse('S6 S7 S8');
    final source = PresetHandDealSource({0: host, 2: partner}, Random(3));
    for (var round = 0; round < 5; round++) {
      final deal = source.nextDeal();
      expect(deal[0] & host, host);
      expect(deal[2] & partner, partner);
      for (final hand in deal) {
        expect(hand.length, handSize);
      }
      expect(deal.fold(CardSet.empty, (all, hand) => all | hand), CardSet.full);
    }
  });
}
