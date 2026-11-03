import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

String legal(String hand, String played, TrumpMode mode) =>
    show(legalMoves(cards(hand), trick(played), mode));

void main() {
  const clubs = TrumpMode.clubs;

  test('anything may be led', () {
    expect(legal('H6 S7 CJ', '', clubs), 'H6 S7 CJ');
  });

  test('must follow suit', () {
    expect(legal('H6 HA S7', 'H9', clubs), 'H6 HA');
  });

  test('may trump instead of following', () {
    expect(legal('H6 S7 C7', 'HA', clubs), 'H6 C7');
  });

  test('anything when unable to follow', () {
    expect(legal('S7 D8 C6', 'HA', clubs), 'D8 S7 C6');
  });

  test('undertrumping is forbidden', () {
    expect(legal('S7 C6', 'HA CK', clubs), 'S7');
    expect(legal('H6 C6', 'HA CK', clubs), 'H6');
  });

  test('overtrumping is allowed', () {
    expect(legal('S7 C9', 'HA CK', clubs), 'S7 C9');
  });

  test('undertrumping is allowed with only trumps', () {
    expect(legal('C6 C7', 'HA CK', clubs), 'C6 C7');
  });

  test('the jack of trump never has to follow trump', () {
    expect(legal('H8 S7 CJ', 'C6', clubs), 'H8 S7 CJ');
  });

  test('trump must be followed when holding more than the jack', () {
    expect(legal('S7 C7 CJ', 'C6', clubs), 'C7 CJ');
  });

  test('without trump, only following matters', () {
    expect(legal('H6 S7', 'HA', TrumpMode.obenabe), 'H6');
    expect(legal('D6 S7', 'HA', TrumpMode.undenufe), 'D6 S7');
  });
}
