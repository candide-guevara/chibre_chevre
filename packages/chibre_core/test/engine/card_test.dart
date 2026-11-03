import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('there are 36 distinct cards', () {
    expect(Card.all, hasLength(36));
    expect(Card.all.toSet(), hasLength(36));
  });

  test('cards are canonical instances', () {
    expect(identical(Card(Suit.hearts, Rank.ace), c('HA')), isTrue);
  });

  test('parse and toString round trip', () {
    for (final card in Card.all) {
      expect(Card.parse(card.toString()), card);
    }
  });

  test('card set operations', () {
    final set = cards('H6 HA S10');
    expect(set.length, 3);
    expect(set.contains(c('HA')), isTrue);
    expect(set.contains(c('HK')), isFalse);
    expect(show(set.ofSuit(Suit.hearts)), 'H6 HA');
    expect(show(set.remove(c('H6')).add(c('C7'))), 'HA S10 C7');
    expect(show(set - cards('HA')), 'H6 S10');
    expect(CardSet.full.length, 36);
    expect(CardSet.suit(Suit.clubs).length, 9);
  });

  test('every mode distributes 152 card points', () {
    for (final mode in TrumpMode.values) {
      expect(pointsOf(Card.all, mode), roundPoints - lastTrickBonus,
          reason: mode.name);
    }
  });

  test('trump order is J 9 A K Q 10 8 7 6', () {
    final order = trick('HJ H9 HA HK HQ H10 H8 H7 H6');
    for (var i = 1; i < order.length; i++) {
      expect(suitStrength(order[i - 1], TrumpMode.hearts),
          greaterThan(suitStrength(order[i], TrumpMode.hearts)));
    }
  });

  test('undenufe reverses the order', () {
    expect(suitStrength(c('S6'), TrumpMode.undenufe),
        greaterThan(suitStrength(c('SA'), TrumpMode.undenufe)));
  });
}
