import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_core/src/ai/world_sampler.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  test('samples respect hand sizes and keep the observer hand', () {
    final round = RoundState(
        options: const GameOptions(), deal: dealOf({}), trumpChooser: 0)
      ..apply(const ChooseTrump(0, TrumpMode.hearts));
    round.apply(PlayCard(0, round.legalCards.cards.first));
    round.apply(PlayCard(1, round.legalCards.cards.first));
    final view = PlayerView.ofRound(round, 2);
    final sampler = WorldSampler(view);
    final random = Random(1);
    for (var i = 0; i < 50; i++) {
      final hands = sampler.sample(random);
      expect(hands[2], view.hand);
      expect(hands.map((h) => h.length), [8, 8, 9, 9]);
      final all = hands.reduce((a, b) => a | b) | view.playedCards;
      expect(all, CardSet.full);
    }
  });

  test('a player who did not follow suit gets no card of that suit', () {
    // Seat 1 has no hearts and discards a diamond on the heart lead.
    final deal = dealOf({
      0: 'H6 H7 H8 H9 H10 S6 S7 S8 S9',
      1: 'D6 D7 D8 D9 D10 DJ DQ DK DA',
    });
    final round =
        RoundState(options: const GameOptions(), deal: deal, trumpChooser: 0)
          ..apply(const ChooseTrump(0, TrumpMode.clubs));
    round.apply(PlayCard(0, c('H6')));
    round.apply(PlayCard(1, c('D6')));
    final view = PlayerView.ofRound(round, 2);
    final sampler = WorldSampler(view);
    final random = Random(2);
    for (var i = 0; i < 100; i++) {
      final hands = sampler.sample(random);
      expect(hands[1].ofSuit(Suit.hearts), CardSet.empty);
    }
  });
}
