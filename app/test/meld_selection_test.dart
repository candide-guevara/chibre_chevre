import 'package:chibre/game/meld_selection.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<int>? values(String cards) =>
      meldsFromSelection(CardSet.parse(cards))?.map((m) => m.value).toList();

  test('a single meld', () => expect(values('H7 H8 H9'), [20]));

  test('several melds selected together', () {
    expect(values('H7 H8 H9 DJ HJ SJ CJ')!..sort(), [20, 200]);
  });

  test('cards that are not all part of melds are refused', () {
    expect(values('H7 H8'), isNull);
    expect(values('H7 H8 H9 SA'), isNull);
  });
}
