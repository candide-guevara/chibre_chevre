import 'package:chibre/game/hand_order.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final hand = CardSet.parse('C6 D9 SJ S9 H7 HA');
  String sorted({required bool byTrump}) =>
      sortHand(hand, TrumpMode.spades, byTrump: byTrump).join(' ');

  test('a fixed order by default: hearts, spades, diamonds, clubs', () {
    expect(sorted(byTrump: false), 'H7 HA S9 SJ D9 C6');
  });

  test('trump first, by strength, when sorting by trump', () {
    expect(sorted(byTrump: true), 'S9 SJ H7 HA D9 C6');
  });
}
