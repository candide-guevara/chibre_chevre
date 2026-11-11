import 'dart:async';

import 'package:chibre/game/game_controller.dart';
import 'package:chibre/screens/play_screen.dart';
import 'package:chibre/strings.dart';
import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre/widgets/played_card.dart';
import 'package:chibre/widgets/playing_card.dart';
import 'package:chibre/widgets/score_board.dart';
import 'package:chibre/widgets/suit_column.dart';
import 'package:chibre/widgets/trick_view.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';

class FakeController implements GameController {
  FakeController(this.table);

  final _tables = StreamController<TableView>.broadcast();
  final actions = <GameAction>[];

  @override
  TableView? table;

  void show(TableView next) {
    table = next;
    _tables.add(next);
  }

  @override
  Stream<TableView> get tables => _tables.stream;

  @override
  void act(GameAction action) => actions.add(action);

  /// What [suggestAction] answers.
  GameAction? suggestion;

  var suggestionsAsked = 0;

  @override
  Future<GameAction> suggestAction() async {
    suggestionsAsked++;
    return suggestion!;
  }

  @override
  void proposeRematch({required bool sameCards}) {}

  @override
  void answerRematch({required bool accept}) {}

  var dismissedRecap = false;
  var choseMelds = false;

  @override
  void meldsChosen() => choseMelds = true;

  @override
  void dismissRecap() => dismissedRecap = true;

  var dismissedRoundSummary = false;

  @override
  void dismissRoundSummary() => dismissedRoundSummary = true;

  @override
  void setAway(bool away) {}

  @override
  Future<void> leave() async {}
}

/// Seat 0 holds the seven of diamonds, so it chooses trump, and a sequence.
GameState newGame() => gameWith(CardSet.parse('D7 H6 H7 H8 S6 S9 SA C10 CK'));

/// Seat 0 holds [hand], which must contain the seven of diamonds.
GameState gameWith(CardSet hand) {
  final rest = (CardSet.full - hand).cards;
  return GameState(
    options: const GameOptions(),
    deals: ReplayDealSource([
      [
        hand,
        for (var seat = 0; seat < 3; seat++)
          CardSet.of(rest.sublist(seat * 9, seat * 9 + 9)),
      ],
    ]),
  );
}

const trickHold = Duration(milliseconds: 700);

TableView tableOf(
  GameState game, {
  int seat = 0,
  List<int> recapFor = const [],
  List<int> roundSummaryFor = const [],
  List<int> meldChoiceFor = const [],
  bool assistance = true,
  bool autoAnnounce = false,
}) => TableView(
  seat: seat,
  nicknames: const ['Ana', 'Ordi 1', 'Bea', 'Ordi 2'],
  options: game.options,
  phase: switch (game.phase) {
    GamePhase.choosingTrump => TablePhase.choosingTrump,
    GamePhase.roundOver => TablePhase.roundOver,
    _ => TablePhase.playing,
  },
  roundIndex: 0,
  scores: game.scores,
  player: game.viewFor(seat),
  seatToAct: game.phase == GamePhase.roundOver ? null : game.seatToAct,
  roundPoints: game.round.points,
  trickHold: trickHold,
  recapFor: recapFor,
  roundSummaryFor: roundSummaryFor,
  meldChoiceFor: meldChoiceFor,
  assistance: assistance,
  autoAnnounce: autoAnnounce,
);

/// Hearts are trump; seat 0 played the queen of hearts and may now play
/// the king, which completes Stöck.
GameState stoeckGame() {
  final game = gameWith(CardSet.parse('D7 H6 H7 H8 H9 H10 HJ HQ HK'))
    ..apply(const ChooseTrump(0, TrumpMode.hearts));
  game.apply(PlayCard(0, Card.parse('HQ')));
  final king = Card.parse('HK');
  while (game.seatToAct != 0 || game.round.currentTrick!.cards.isEmpty) {
    final seat = game.seatToAct;
    final legal = game.viewFor(seat).legalCards;
    game.apply(
      PlayCard(
        seat,
        seat == 0
            ? (legal - CardSet.of([king])).cards.first
            : legal.cards.first,
      ),
    );
  }
  return game;
}

Future<void> pumpScreen(WidgetTester tester, FakeController controller) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: chibreTheme(),
      home: PlayScreen(controller: controller),
    ),
  );
}

void main() {
  testWidgets('the trump chooser picks a suit', (tester) async {
    final game = newGame();
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    expect(find.text(Strings.chooseTrump), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(Strings.modeName(TrumpMode.hearts)));
    expect(controller.actions.single.toString(), 'ChooseTrump(0, hearts)');
  });

  testWidgets('tapping a legal card plays it, illegal cards are ignored', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    await tester.tap(find.text(Strings.skipMelds));
    await tester.pump();
    expect(controller.choseMelds, isTrue);
    expect(find.text(Strings.yourTurn), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('SA'))));
    final play = controller.actions.single as PlayCard;
    expect(play.card, Card.parse('SA'));
    expect(play.melds, isEmpty);
  });

  testWidgets('melds are selected, validated and sent with the card', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.clubs));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    expect(find.text(Strings.chooseMelds), findsOneWidget);

    // Selecting a card turns the button into a validation.
    for (final card in ['H6', 'H8']) {
      await tester.tap(
        find.bySemanticsLabel(Strings.cardName(Card.parse(card))),
      );
    }
    await tester.pump();
    expect(find.text(Strings.skipMelds), findsNothing);
    await tester.tap(find.text(Strings.validateMelds));
    await tester.pump();
    expect(find.text(Strings.notAMeld), findsOneWidget);
    expect(controller.actions, isEmpty);

    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('H7'))));
    await tester.pump();
    await tester.tap(find.text(Strings.validateMelds));
    await tester.pump();
    expect(find.textContaining('20 ('), findsOneWidget);
    expect(find.text(Strings.validateMelds), findsNothing); // No going back.
    expect(controller.choseMelds, isTrue);

    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('SA'))));
    final play = controller.actions.single as PlayCard;
    expect(play.melds.single.value, 20);
  });

  testWidgets('a paused game shows who it waits for', (tester) async {
    final game = newGame();
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    final paused = tableOf(game).copyWith(pausedFor: 'Bea');
    controller.show(paused);
    await tester.pump();
    expect(find.text(Strings.waitingFor('Bea')), findsOneWidget);
  });

  testWidgets('melds can be prepared before the player\'s turn', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game, seat: 2));
    await pumpScreen(tester, controller);
    expect(find.text(Strings.chooseMelds), findsOneWidget);
    await tester.tap(find.text(Strings.skipMelds));
    controller.show(tableOf(game, seat: 2, meldChoiceFor: [0]));
    await tester.pump();
    expect(find.text(Strings.choosesMelds('Ana')), findsOneWidget);
    controller.show(tableOf(game, seat: 2));
    await tester.pump();
    expect(find.text(Strings.plays('Ana')), findsOneWidget);
  });

  testWidgets('a complete trick slides away towards its winner', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    for (var i = 0; i < 4; i++) {
      final seat = game.seatToAct;
      game.apply(PlayCard(seat, game.viewFor(seat).legalCards.cards.first));
    }
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    double opacity() => tester
        .widget<Opacity>(
          find.descendant(
            of: find.byType(TrickView),
            matching: find.byType(Opacity),
          ),
        )
        .opacity;
    expect(opacity(), 1);
    const timing = SessionTiming();
    await tester.pump(timing.cardSlide + trickHold);
    expect(opacity(), 1);
    await tester.pump(timing.trickSlide);
    expect(opacity(), 0);
  });

  testWidgets('the meld recap is shown until the player closes it', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final sequence = Meld.fromCards(CardSet.parse('H6 H7 H8'))!;
    game.apply(PlayCard(0, Card.parse('SA'), melds: [sequence]));
    // An opponent's sequence of the same value with a higher card: it wins.
    final opponents = Meld.fromCards(CardSet.parse('D8 D9 D10'))!;
    final opponentCard = game.viewFor(1).legalCards.cards.first;
    game.apply(PlayCard(1, opponentCard, melds: [opponents]));
    for (var i = 0; i < 2; i++) {
      final seat = game.seatToAct;
      game.apply(PlayCard(seat, game.viewFor(seat).legalCards.cards.first));
    }
    final controller = FakeController(tableOf(game, recapFor: [0, 2]));
    await pumpScreen(tester, controller);
    expect(find.text(Strings.announcements), findsOneWidget);
    expect(
      find.textContaining(Strings.playerLine('Ana', '20 (')),
      findsOneWidget,
    );
    expect(
      find.textContaining(Strings.playerLine('Ordi 1', '20 (')),
      findsOneWidget,
    );
    expect(find.text(Strings.gain(ours: false, points: 20)), findsOneWidget);

    await tester.tap(find.text(Strings.announcements));
    expect(controller.dismissedRecap, isTrue);

    controller.show(tableOf(game, recapFor: [2]));
    await tester.pump();
    expect(find.text(Strings.announcements), findsNothing);
    expect(find.text(Strings.readsAnnouncements('Bea')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('the round summary waits for the last trick, then closes on '
      'a tap', (tester) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    while (game.phase == GamePhase.playing) {
      final seat = game.seatToAct;
      game.apply(PlayCard(seat, game.viewFor(seat).legalCards.cards.first));
    }
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    expect(find.text(Strings.roundOver), findsNothing);

    controller.show(tableOf(game, roundSummaryFor: [0, 2]));
    await tester.pump();
    await tester.tap(find.text(Strings.roundOver));
    expect(controller.dismissedRoundSummary, isTrue);

    controller.show(tableOf(game, roundSummaryFor: [2]));
    await tester.pump();
    expect(find.text(Strings.roundOver), findsNothing);
    expect(find.text(Strings.readsRoundSummary('Bea')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('a played card slides in, cards already played stay put', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    game.apply(PlayCard(0, Card.parse('SA')));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    await tester.pump(const SessionTiming().cardSlide);

    final second = game.viewFor(1).legalCards.cards.first;
    game.apply(PlayCard(1, second));
    controller.show(tableOf(game));
    await tester.pump();
    double offsetOf(Card card) => tester
        .widget<Transform>(
          find
              .descendant(
                of: find.byWidgetPredicate(
                  (widget) => widget is PlayedCard && widget.card == card,
                ),
                matching: find.byType(Transform),
              )
              .first,
        )
        .transform
        .getTranslation()
        .x;
    expect(offsetOf(Card.parse('SA')), 0);
    expect(offsetOf(second), greaterThan(0)); // From the right.
    await tester.pump(const SessionTiming().cardSlide);
    expect(offsetOf(second), 0);
  });

  testWidgets('names and the score bar stay in place during the game', (
    tester,
  ) async {
    final game = newGame();
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    Map<String, double> layout() => {
      for (final name in ['Ana', 'Ordi 1', 'Bea', 'Ordi 2'])
        name: tester.getRect(find.text(name)).top,
      'scores': tester.getRect(find.byType(ScoreBoard)).height,
    };
    final choosing = layout(); // Trump buttons in the action area.

    game.apply(const ChooseTrump(0, TrumpMode.hearts));
    controller.show(tableOf(game));
    await tester.pump();
    expect(layout(), choosing); // Meld buttons, trump in the score bar.

    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('H7'))));
    await tester.pump();
    expect(layout(), choosing);
    await tester.tap(find.text(Strings.validateMelds));
    await tester.pump();
    expect(layout(), choosing);

    game.apply(PlayCard(0, Card.parse('SA')));
    controller.show(tableOf(game));
    await tester.pump(const Duration(milliseconds: 300));
    expect(layout(), choosing); // A status line only.
  });

  testWidgets('the Stöck button above the card plays it with Stöck', (
    tester,
  ) async {
    final game = stoeckGame();
    final king = Card.parse('HK');
    expect(game.viewFor(0).legalCards.contains(king), isTrue);
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    await tester.pump(const Duration(milliseconds: 300));

    final chip = tester.getCenter(find.text(Strings.stoeck));
    final card = tester.getRect(
      find.bySemanticsLabel(Strings.cardName(Card.parse('HK'))),
    );
    expect(chip.dy, lessThan(card.top));
    await tester.tap(find.text(Strings.stoeck));
    final play = controller.actions.single as PlayCard;
    expect(play.card, king);
    expect(play.stoeck, isTrue);

    // Once the trick is over, a pop-up says who announced Stöck.
    game.apply(play);
    while (game.round.currentTrick!.cards.isNotEmpty) {
      final seat = game.seatToAct;
      game.apply(PlayCard(seat, game.viewFor(seat).legalCards.cards.first));
    }
    controller.show(tableOf(game, recapFor: [0, 2]));
    await tester.pump();
    expect(
      find.text(Strings.playerLine('Ana', Strings.stoeck)),
      findsOneWidget,
    );
    expect(find.text(Strings.gain(ours: true, points: 20)), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('automatic announcements offer the melds in a pop-up', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.clubs));
    final controller = FakeController(tableOf(game, autoAnnounce: true));
    await pumpScreen(tester, controller);
    expect(find.text(Strings.yourMelds), findsOneWidget);
    expect(find.text(Strings.skipMelds), findsNothing);

    // Cards cannot be played before deciding.
    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('SA'))));
    expect(controller.actions, isEmpty);

    await tester.tap(find.text(Strings.announce));
    await tester.pump();
    expect(find.text(Strings.yourMelds), findsNothing);
    expect(controller.choseMelds, isTrue);
    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('SA'))));
    final play = controller.actions.single as PlayCard;
    expect(play.melds.single.value, 20);
  });

  testWidgets('automatic announcements: melds can be kept secret', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.clubs));
    final controller = FakeController(tableOf(game, autoAnnounce: true));
    await pumpScreen(tester, controller);
    await tester.tap(find.text(Strings.keepSecret));
    await tester.pump();
    expect(find.text(Strings.yourMelds), findsNothing);
    expect(controller.choseMelds, isTrue);
    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('SA'))));
    expect((controller.actions.single as PlayCard).melds, isEmpty);
  });

  testWidgets('automatic announcements: nothing to decide without melds', (
    tester,
  ) async {
    final game = gameWith(CardSet.parse('D7 H6 H8 H10 S6 S9 SA C10 CK'))
      ..apply(const ChooseTrump(0, TrumpMode.clubs));
    final controller = FakeController(tableOf(game, autoAnnounce: true));
    await pumpScreen(tester, controller);
    expect(find.text(Strings.yourMelds), findsNothing);
    expect(controller.choseMelds, isTrue);
    expect(find.text(Strings.yourTurn), findsOneWidget);
  });

  testWidgets('automatic announcements: Stöck is announced with the card', (
    tester,
  ) async {
    final controller = FakeController(
      tableOf(stoeckGame(), autoAnnounce: true),
    );
    await pumpScreen(tester, controller);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(Strings.stoeck), findsNothing);
    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('HK'))));
    final play = controller.actions.single as PlayCard;
    expect(play.card, Card.parse('HK'));
    expect(play.stoeck, isTrue);
  });

  testWidgets('"Jouer pour moi" highlights a card, the player plays it', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game))
      ..suggestion = PlayCard(0, Card.parse('SA'));
    await pumpScreen(tester, controller);
    PlayingCard card(String name) => tester.widget<PlayingCard>(
      find.byWidgetPredicate(
        (widget) => widget is PlayingCard && widget.card == Card.parse(name),
      ),
    );

    await tester.tap(find.text(Strings.skipMelds));
    await tester.pump();
    await tester.tap(find.text(Strings.playForMe));
    await tester.pump();
    expect(controller.actions, isEmpty);
    expect(card('SA').selected, isTrue);

    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('SA'))));
    final play = controller.actions.single as PlayCard;
    expect(play.card, Card.parse('SA'));
    expect(play.melds, isEmpty); // The player chose not to announce.
  });

  testWidgets('"Jouer pour moi" leaves the player free to play another card', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game))
      ..suggestion = PlayCard(0, Card.parse('SA'));
    await pumpScreen(tester, controller);
    await tester.tap(find.text(Strings.skipMelds));
    await tester.pump();
    await tester.tap(find.text(Strings.playForMe));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel(Strings.cardName(Card.parse('S6'))));
    expect((controller.actions.single as PlayCard).card, Card.parse('S6'));
  });

  testWidgets('the suggestion is computed before "Jouer pour moi" is pressed', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game))
      ..suggestion = PlayCard(0, Card.parse('SA'));
    await pumpScreen(tester, controller);
    expect(controller.suggestionsAsked, 0); // Still choosing melds.

    await tester.tap(find.text(Strings.skipMelds));
    await tester.pump();
    expect(controller.suggestionsAsked, 1);

    await tester.tap(find.text(Strings.playForMe));
    await tester.pump();
    expect(controller.suggestionsAsked, 1);
  });

  testWidgets('"Jouer pour moi" only outlines the suggested trump', (
    tester,
  ) async {
    final controller = FakeController(tableOf(newGame()))
      ..suggestion = const ChooseTrump(0, TrumpMode.spades);
    await pumpScreen(tester, controller);
    await tester.tap(find.text(Strings.playForMe));
    await tester.pump();
    expect(controller.actions, isEmpty);
    final spades = tester.widget<FilledButton>(
      find.ancestor(
        of: find.bySemanticsLabel(Strings.modeName(TrumpMode.spades)),
        matching: find.byType(FilledButton),
      ),
    );
    expect(spades.style!.side!.resolve({}), isNotNull);
  });

  testWidgets('"Jouer pour moi" is disabled while choosing melds', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    final button = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text(Strings.playForMe),
        matching: find.byType(OutlinedButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('"Cartes jouées" shows the announcements and cards by suit', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final sequence = Meld.fromCards(CardSet.parse('H6 H7 H8'))!;
    game.apply(PlayCard(0, Card.parse('SA'), melds: [sequence]));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    await tester.tap(find.text(Strings.playedCards));
    await tester.pumpAndSettle();
    expect(
      find.textContaining(Strings.playerLine('Ana', '20 (')),
      findsOneWidget,
    );
    expect(find.byType(Divider), findsOneWidget);
    expect(find.byType(SuitColumn), findsNWidgets(4));
    expect(
      find.descendant(
        of: find.byType(SuitColumn).at(1), // Spades.
        matching: find.byWidgetPredicate(
          (widget) => widget is PlayingCard && widget.card == Card.parse('SA'),
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('the assistance buttons are only shown when the host chose so', (
    tester,
  ) async {
    final controller = FakeController(tableOf(newGame(), assistance: false));
    await pumpScreen(tester, controller);
    expect(find.text(Strings.playForMe), findsNothing);
    expect(find.text(Strings.playedCards), findsNothing);
  });
}
