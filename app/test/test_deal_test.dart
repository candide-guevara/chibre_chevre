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

  test('the host always holds the seven of diamonds', () {
    for (final deal in TestDeal.values) {
      expect(deal.presets[0]!.contains(Card.parse('D7')), isTrue);
    }
  });

  test(
    'in the sequence deal, everyone has a sequence and the host\'s wins',
    () {
      final hands = TestDeal.sequence.presets;
      expect(
        hands.values.fold(CardSet.empty, (all, hand) => all | hand),
        CardSet.full,
      );
      final melds = [
        for (var seat = 0; seat < 4; seat++) findBestMelds(hands[seat]!),
      ];
      expect(melds.map((m) => m.single.value), [50, 20, 20, 20]);
      for (final mode in TrumpMode.values) {
        for (var first = 0; first < 4; first++) {
          expect(winningMeldTeam(melds, mode, first), 0);
        }
      }
    },
  );
}
