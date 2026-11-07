import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

void main() {
  test('the preset seat always holds its cards, deals stay valid', () {
    final preset = CardSet.parse('D7 D9 DJ DA');
    final source = PresetHandDealSource(0, preset, Random(3));
    for (var round = 0; round < 5; round++) {
      final deal = source.nextDeal();
      expect(deal[0] & preset, preset);
      for (final hand in deal) {
        expect(hand.length, handSize);
      }
      expect(deal.fold(CardSet.empty, (all, hand) => all | hand), CardSet.full);
    }
  });
}
