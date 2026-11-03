import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('highest card of the led suit wins', () {
    expect(winningIndex(trick('H9 HA SA H6'), TrumpMode.clubs), 1);
  });

  test('any trump beats the led suit', () {
    expect(winningIndex(trick('HA H6 C6 HK'), TrumpMode.clubs), 2);
  });

  test('the jack is the highest trump, then the nine', () {
    expect(winningIndex(trick('HA C6 CJ C9'), TrumpMode.clubs), 2);
    expect(winningIndex(trick('CA C9 C6 CK'), TrumpMode.clubs), 1);
  });

  test('obenabe and undenufe', () {
    expect(winningIndex(trick('H9 HA SA'), TrumpMode.obenabe), 1);
    expect(winningIndex(trick('H9 H6 HA'), TrumpMode.undenufe), 1);
  });

  test('seats and points', () {
    final t = Trick(3, trick('H9 HA C6 HK'));
    expect(t.seatAt(1), 0);
    expect(t.cardOf(1), c('C6'));
    expect(t.winner(TrumpMode.clubs), 1);
    expect(t.points(TrumpMode.clubs), 15);
    expect(t.points(TrumpMode.hearts), 14 + 11 + 4);
  });
}
