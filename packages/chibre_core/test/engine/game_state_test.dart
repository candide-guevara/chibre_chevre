import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

/// Plays the game with a first-legal-card strategy, choosing [mode].
void playUntilOver(GameState game, {TrumpMode mode = TrumpMode.hearts}) {
  while (game.phase != GamePhase.gameOver) {
    switch (game.phase) {
      case GamePhase.roundOver:
        game.startNextRound();
      case GamePhase.choosingTrump:
        game.apply(ChooseTrump(game.seatToAct, mode));
      case GamePhase.playing:
        game.apply(PlayCard(game.seatToAct, game.round.legalCards.cards.first));
      case GamePhase.gameOver:
    }
  }
}

void main() {
  test('the holder of the seven of diamonds chooses trump first', () {
    final deal = dealOf({2: 'D7 H6 H7 H8 H9 H10 HJ HQ HK'});
    final game = GameState(
        options: const GameOptions(), deals: ReplayDealSource([deal]));
    expect(game.phase, GamePhase.choosingTrump);
    expect(game.seatToAct, 2);
  });

  test('the trump choice rotates to the next seat each round', () {
    final deal = dealOf({2: 'D7 H6 H7 H8 H9 H10 HJ HQ HK'});
    final game = GameState(
        options: const GameOptions(), deals: ReplayDealSource([deal]));
    game.apply(const ChooseTrump(2, TrumpMode.hearts));
    playFirstLegalCards(game.round);
    expect(game.phase, GamePhase.roundOver);
    game.startNextRound();
    expect(game.round.trumpChooser, 3);
    expect(game.roundIndex, 1);
  });

  test('the next round can be seen ahead, and is the one started', () {
    final first = dealOf({2: 'D7 H6 H7 H8 H9 H10 HJ HQ HK'});
    final second = dealOf({3: 'D7 S6 S7 S8 S9 S10 SJ SQ SK'});
    final game = GameState(
        options: const GameOptions(),
        deals: ReplayDealSource([first, second]));
    game.apply(const ChooseTrump(2, TrumpMode.hearts));
    playFirstLegalCards(game.round);
    expect(game.nextTrumpChooser, 3);
    final ahead = game.nextRoundViewFor(3);
    expect(ahead.hand, second[3]);
    expect(game.nextRoundViewFor(0).hand, second[0]); // Dealt only once.
    expect(game.phase, GamePhase.roundOver);

    game.startNextRound();
    expect(game.round.handOf(3), second[3]);
    expect(game.record.rounds.last.deal, second);
  });

  test('the game ends as soon as a team reaches the target, even mid-round',
      () {
    final game = GameState(
        options: const GameOptions(targetScore: 40),
        deals: RandomDealSource(Random(3)));
    playUntilOver(game);
    expect(game.winningTeam, isNotNull);
    expect(game.scores[game.winningTeam!], greaterThanOrEqualTo(40));
    expect(game.round.phase, isNot(RoundPhase.choosingTrump));
    expect(() => game.apply(const Chibrer(0)),
        throwsA(isA<IllegalActionException>()));
  });

  test('scores add up the round points until the target', () {
    final game = GameState(
        options: const GameOptions(targetScore: 1000),
        deals: RandomDealSource(Random(5)));
    playUntilOver(game);
    expect(game.scores.reduce(max), greaterThanOrEqualTo(1000));
    expect(game.record.rounds.length, greaterThan(3));
  });

  test('a record replays to the same result', () {
    final game = GameState(
        options: const GameOptions(), deals: RandomDealSource(Random(7)));
    playUntilOver(game, mode: TrumpMode.spades);

    final replay = GameState.replaying(game.record);
    for (final (index, round) in game.record.rounds.indexed) {
      if (index > 0) replay.startNextRound();
      round.actions.forEach(replay.apply);
    }
    expect(replay.scores, game.scores);
    expect(replay.winningTeam, game.winningTeam);
  });

  test('a replay deal source falls back once the deals run out', () {
    final deal = dealOf({});
    final source =
        ReplayDealSource([deal], fallback: RandomDealSource(Random(1)));
    expect(source.nextDeal(), deal);
    expect(source.nextDeal(), isNot(deal));
  });

  test('a player view only shows the own hand', () {
    final game = GameState(
        options: const GameOptions(), deals: RandomDealSource(Random(2)));
    final view = game.viewFor(1);
    expect(view.hand, game.round.handOf(1));
    expect(view.handSizeOf(3), 9);
    expect(view.mode, isNull);
  });

  test('every meld is shown once the first trick is over', () {
    final game = GameState(
      options: const GameOptions(),
      deals: ReplayDealSource([
        dealOf({
          0: 'D7 H6 H7 H8 S6 S9 SA C10 CK',
          1: 'S7 S8 S9 C6 D9 DJ DQ HJ CK'
        }),
      ]),
    );
    game.apply(const ChooseTrump(0, TrumpMode.hearts));
    final sequence = Meld.fromCards(cards('H6 H7 H8'))!;
    final other = Meld.fromCards(cards('S7 S8 S9'))!;
    game.apply(PlayCard(0, c('D7'), melds: [sequence]));
    game.apply(PlayCard(1, c('D9'), melds: [other]));
    expect(game.viewFor(2).revealedMelds[1], isEmpty);
    expect(game.viewFor(1).revealedMelds[1], [other]);
    while (game.round.completedTricks.isEmpty) {
      final seat = game.seatToAct;
      game.apply(PlayCard(seat, game.round.legalCards.cards.first));
    }
    for (var viewer = 0; viewer < seatCount; viewer++) {
      expect(game.viewFor(viewer).revealedMelds[0], [sequence]);
      expect(game.viewFor(viewer).revealedMelds[1], [other]);
    }
  });
}
