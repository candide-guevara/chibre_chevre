import 'package:chibre/services/test_deal.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the flag is read in both forms', () {
    expect(TestDeal.fromArgs([]), isNull);
    expect(TestDeal.fromArgs(['--test-fix-deal=stock']), TestDeal.stoeck);
    expect(
      TestDeal.fromArgs(['--test-fix-deal', 'good-hand']),
      TestDeal.goodHand,
    );
    expect(
      () => TestDeal.fromArgs(['--test-fix-deal=royal']),
      throwsArgumentError,
    );
  });

  test('each hand holds the seven of diamonds and its meld', () {
    for (final deal in TestDeal.values) {
      expect(deal.cards.contains(Card.parse('D7')), isTrue);
    }
    expect(findBestMelds(TestDeal.sequence.cards).single.value, 50);
  });
}
