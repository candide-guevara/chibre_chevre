import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

const allSpades = 'S6 S7 S8 S9 S10 SJ SQ SK SA';

RoundState newRound(List<CardSet> deal,
        {int chooser = 0, GameOptions options = const GameOptions()}) =>
    RoundState(options: options, deal: deal, trumpChooser: chooser);

void main() {
  final randomish = dealOf({});

  group('trump choice', () {
    test('the chooser picks trump and leads', () {
      final round = newRound(randomish, chooser: 1);
      expect(round.phase, RoundPhase.choosingTrump);
      expect(round.seatToAct, 1);
      round.apply(const ChooseTrump(1, TrumpMode.hearts));
      expect(round.phase, RoundPhase.playing);
      expect(round.mode, TrumpMode.hearts);
      expect(round.seatToAct, 1);
    });

    test('chibrer passes the choice to the partner, the chooser still leads',
        () {
      final round = newRound(randomish, chooser: 1);
      round.apply(const Chibrer(1));
      expect(round.seatToAct, 3);
      expect(() => round.apply(const Chibrer(3)),
          throwsA(isA<IllegalActionException>()));
      round.apply(const ChooseTrump(3, TrumpMode.clubs));
      expect(round.seatToAct, 1);
    });

    test('only allowed modes can be chosen', () {
      final round = newRound(randomish);
      expect(() => round.apply(const ChooseTrump(0, TrumpMode.obenabe)),
          throwsA(isA<IllegalActionException>()));
      newRound(randomish, options: const GameOptions(obenUndeAllowed: true))
          .apply(const ChooseTrump(0, TrumpMode.obenabe));
    });

    test('other seats cannot choose', () {
      expect(
          () =>
              newRound(randomish).apply(const ChooseTrump(2, TrumpMode.hearts)),
          throwsA(isA<IllegalActionException>()));
    });
  });

  group('card play', () {
    test('rejects playing out of turn, cards not in hand and illegal cards',
        () {
      final deal = dealOf(
          {0: 'H6 H7 H8 H9 S6 S7 S8 S9 S10', 1: 'HA SA SK SQ SJ D6 D7 D8 D9'});
      final round = newRound(deal)
        ..apply(const ChooseTrump(0, TrumpMode.clubs));
      expect(() => round.apply(PlayCard(1, c('HA'))),
          throwsA(isA<IllegalActionException>()));
      expect(() => round.apply(PlayCard(0, c('HA'))),
          throwsA(isA<IllegalActionException>()));
      round.apply(PlayCard(0, c('H6')));
      expect(() => round.apply(PlayCard(1, c('SA'))),
          throwsA(isA<IllegalActionException>()));
      round.apply(PlayCard(1, c('HA')));
    });

    test('a round distributes 157 points', () {
      for (final mode in TrumpMode.values) {
        final round = newRound(randomish,
            options: const GameOptions(obenUndeAllowed: true))
          ..apply(ChooseTrump(0, mode));
        playFirstLegalCards(round);
        expect(round.phase, RoundPhase.over);
        expect(round.points[0] + round.points[1], anyOf(157, 257),
            reason: mode.name);
        expect(round.tricksWon[0] + round.tricksWon[1], 9);
      }
    });

    test('winning all tricks scores the match bonus', () {
      final round = newRound(dealOf({0: allSpades}))
        ..apply(const ChooseTrump(0, TrumpMode.spades));
      playFirstLegalCards(round);
      expect(round.points, [257, 0]);
    });

    test('multipliers apply to trick points', () {
      final round = newRound(dealOf({0: allSpades}),
          options: const GameOptions(multipliersEnabled: true))
        ..apply(const ChooseTrump(0, TrumpMode.spades));
      playFirstLegalCards(round);
      expect(round.points, [514, 0]);
    });
  });

  group('melds', () {
    final deal = dealOf({
      0: 'H6 H7 H8 S6 S7 D6 D7 C6 C7',
      1: 'H9 H10 HJ HQ S8 D8 C8 S9 D9',
    });

    test('the best meld wins and is counted before the trick', () {
      final round = newRound(deal)
        ..apply(const ChooseTrump(0, TrumpMode.clubs));
      round.apply(
          PlayCard(0, c('S6'), melds: [Meld.fromCards(cards('H6 H7 H8'))!]));
      round.apply(PlayCard(1, c('S8'),
          melds: [Meld.fromCards(cards('H9 H10 HJ HQ'))!]));
      round.apply(PlayCard(2, round.legalCards.cards.first));
      final entries = round.apply(PlayCard(3, round.legalCards.cards.first));
      expect(round.meldWinningTeam, 1);
      expect(entries.first.reason, ScoreReason.melds);
      expect(entries.first.team, 1);
      expect(entries.first.points, 50);
      expect(entries.last.reason, ScoreReason.trick);
    });

    test('melds are only allowed in the first trick', () {
      final round = newRound(deal)
        ..apply(const ChooseTrump(0, TrumpMode.clubs));
      for (var i = 0; i < 4; i++) {
        round.apply(PlayCard(round.seatToAct, round.legalCards.cards.first));
      }
      final seat = round.seatToAct;
      final hand = round.handOf(seat);
      final melds = findBestMelds(hand);
      if (melds.isEmpty) return;
      expect(
          () => round.apply(
              PlayCard(seat, round.legalCards.cards.first, melds: melds)),
          throwsA(isA<IllegalActionException>()));
    });

    test('invalid melds are rejected', () {
      final round = newRound(deal)
        ..apply(const ChooseTrump(0, TrumpMode.clubs));
      expect(
          () => round.apply(PlayCard(0, c('S6'),
              melds: [Meld.fromCards(cards('H9 H10 HJ'))!])),
          throwsA(isA<IllegalActionException>()));
    });
  });

  group('stöck', () {
    final deal = dealOf({0: allSpades});

    test('is announced with the second of king and queen', () {
      final round = newRound(deal)
        ..apply(const ChooseTrump(0, TrumpMode.spades));
      expect(round.canAnnounceStoeck(0, c('SK')), isFalse);
      expect(() => round.apply(PlayCard(0, c('SK'), stoeck: true)),
          throwsA(isA<IllegalActionException>()));
      round.apply(PlayCard(0, c('SK')));
      for (var i = 0; i < 3; i++) {
        round.apply(PlayCard(round.seatToAct, round.legalCards.cards.first));
      }
      expect(round.seatToAct, 0);
      final entries = round.apply(PlayCard(0, c('SQ'), stoeck: true));
      expect(entries.single.reason, ScoreReason.stoeck);
      expect(entries.single.points, 20);
      expect(round.stoeckSeat, 0);
    });

    test('does not exist without trump', () {
      final round =
          newRound(deal, options: const GameOptions(obenUndeAllowed: true))
            ..apply(const ChooseTrump(0, TrumpMode.obenabe));
      round.apply(PlayCard(0, c('SK')));
      expect(round.canAnnounceStoeck(0, c('SQ')), isFalse);
    });
  });
}
