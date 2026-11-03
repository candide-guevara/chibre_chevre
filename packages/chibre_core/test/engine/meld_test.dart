import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

Meld meld(String text) => Meld.fromCards(cards(text))!;

void main() {
  group('fromCards', () {
    test('sequences', () {
      expect(meld('H6 H7 H8').value, 20);
      expect(meld('H6 H7 H8 H9').value, 50);
      expect(meld('H6 H7 H8 H9 H10').value, 100);
      expect(meld('S9 S10 SJ SQ SK SA').value, 150);
      expect(Meld.fromCards(CardSet.suit(Suit.clubs))!.value, 300);
    });

    test('four of a kind', () {
      expect(meld('DJ HJ SJ CJ').value, 200);
      expect(meld('D9 H9 S9 C9').value, 150);
      expect(meld('DA HA SA CA').value, 100);
      expect(meld('D10 H10 S10 C10').value, 100);
    });

    test('invalid melds', () {
      expect(Meld.fromCards(cards('H6 H7 H9')), isNull);
      expect(Meld.fromCards(cards('H6 H7 S8')), isNull);
      expect(Meld.fromCards(cards('H6 H7')), isNull);
      expect(Meld.fromCards(cards('D8 H8 S8 C8')), isNull);
      expect(Meld.fromCards(cards('DJ HJ SJ')), isNull);
    });
  });

  test('findBestMelds finds maximal sequences and fours of a kind', () {
    final melds = findBestMelds(cards('H6 H7 H8 H9 HJ DJ SJ CJ SA'));
    expect(melds.map((m) => m.value), unorderedEquals([50, 200]));
    expect(findBestMelds(cards('H6 H7 H9 S10 SQ SA D6 D7 C8')), isEmpty);
  });

  group('validateMelds', () {
    final hand = cards('H6 H7 H8 H9 H10 HJ DJ SJ CJ');

    test('accepts a sequence and a four of a kind sharing a card', () {
      expect(
          validateMelds(
              [meld('H6 H7 H8 H9 H10 HJ'), meld('DJ HJ SJ CJ')], hand),
          isNull);
    });

    test('rejects cards not in hand', () {
      expect(validateMelds([meld('S6 S7 S8')], hand), MeldError.notInHand);
    });

    test('rejects overlapping sequences', () {
      expect(validateMelds([meld('H6 H7 H8'), meld('H7 H8 H9')], hand),
          MeldError.overlapping);
      expect(validateMelds([meld('H6 H7 H8'), meld('H6 H7 H8')], hand),
          MeldError.overlapping);
    });
  });

  group('comparison', () {
    test('higher value wins', () {
      expect(
          compareMelds(meld('H6 H7 H8 H9'), meld('SQ SK SA'), TrumpMode.hearts),
          greaterThan(0));
    });

    test('at equal value, more cards win', () {
      expect(
          compareMelds(
              meld('H6 H7 H8 H9 H10'), meld('DA HA SA CA'), TrumpMode.clubs),
          greaterThan(0));
    });

    test('at equal length, higher cards win', () {
      expect(compareMelds(meld('SQ SK SA'), meld('H6 H7 H8'), TrumpMode.hearts),
          greaterThan(0));
    });

    test('in undenufe, lower cards win', () {
      expect(
          compareMelds(meld('SQ SK SA'), meld('H6 H7 H8'), TrumpMode.undenufe),
          lessThan(0));
    });

    test('at equal height, trump wins', () {
      expect(compareMelds(meld('S6 S7 S8'), meld('H6 H7 H8'), TrumpMode.hearts),
          lessThan(0));
    });

    test('perfect ties go to the first player to announce', () {
      final melds = [
        [meld('S6 S7 S8')],
        [meld('D6 D7 D8')],
        <Meld>[],
        <Meld>[],
      ];
      expect(winningMeldTeam(melds, TrumpMode.hearts, 0), 0);
      expect(winningMeldTeam(melds, TrumpMode.hearts, 1), 1);
      expect(winningMeldTeam([[], [], [], []], TrumpMode.hearts, 0), isNull);
    });
  });
}
