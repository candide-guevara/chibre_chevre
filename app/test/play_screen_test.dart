import 'dart:async';

import 'package:chibre/game/game_controller.dart';
import 'package:chibre/screens/play_screen.dart';
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

  @override
  Future<GameAction> suggestAction() async => suggestion!;

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

  @override
  void setAway(bool away) {}

  @override
  Future<void> leave() async {}
}

/// Seat 0 holds the seven of diamonds, so it chooses trump, and a sequence.
GameState newGame() {
  final hand = CardSet.parse('D7 H6 H7 H8 S6 S9 SA C10 CK');
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

TableView tableOf(
  GameState game, {
  int seat = 0,
  List<int> recapFor = const [],
  List<int> meldChoiceFor = const [],
  bool assistance = true,
}) => TableView(
  seat: seat,
  nicknames: const ['Ana', 'Ordi 1', 'Bea', 'Ordi 2'],
  options: game.options,
  cardStyle: CardStyle.cow,
  phase: game.phase == GamePhase.choosingTrump
      ? TablePhase.choosingTrump
      : TablePhase.playing,
  roundIndex: 0,
  scores: game.scores,
  player: game.viewFor(seat),
  seatToAct: game.seatToAct,
  roundPoints: game.round.points,
  trickHold: const Duration(milliseconds: 700),
  recapFor: recapFor,
  meldChoiceFor: meldChoiceFor,
  assistance: assistance,
);

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
    expect(find.text('Choisissez l\'atout'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Atout cœur'));
    expect(controller.actions.single.toString(), 'ChooseTrump(0, hearts)');
  });

  testWidgets('tapping a legal card plays it, illegal cards are ignored', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    await tester.tap(find.text('Ne pas annoncer, jouer'));
    await tester.pump();
    expect(controller.choseMelds, isTrue);
    expect(find.text('À vous de jouer'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('as de pique'));
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
    expect(find.text('Choisissez votre annonce'), findsOneWidget);

    // Selecting a card turns the button into a validation.
    for (final name in ['6 de cœur', '8 de cœur']) {
      await tester.tap(find.bySemanticsLabel(name));
    }
    await tester.pump();
    expect(find.text('Ne pas annoncer, jouer'), findsNothing);
    await tester.tap(find.text('Valider l\'annonce'));
    await tester.pump();
    expect(find.text('Ces cartes ne forment pas une annonce.'), findsOneWidget);
    expect(controller.actions, isEmpty);

    await tester.tap(find.bySemanticsLabel('7 de cœur'));
    await tester.pump();
    await tester.tap(find.text('Valider l\'annonce'));
    await tester.pump();
    expect(find.textContaining('20 ('), findsOneWidget);
    expect(find.text('Valider l\'annonce'), findsNothing); // No going back.
    expect(controller.choseMelds, isTrue);

    await tester.tap(find.bySemanticsLabel('as de pique'));
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
    expect(find.text('En attente de Bea…'), findsOneWidget);
  });

  testWidgets('melds can be prepared before the player\'s turn', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game, seat: 2));
    await pumpScreen(tester, controller);
    expect(find.text('Choisissez votre annonce'), findsOneWidget);
    await tester.tap(find.text('Ne pas annoncer, jouer'));
    controller.show(tableOf(game, seat: 2, meldChoiceFor: [0]));
    await tester.pump();
    expect(find.text('Ana choisit son annonce…'), findsOneWidget);
    controller.show(tableOf(game, seat: 2));
    await tester.pump();
    expect(find.text('Ana joue…'), findsOneWidget);
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
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 400));
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
    expect(find.text('Annonces'), findsOneWidget);
    expect(find.textContaining('Ana : 20 ('), findsOneWidget);
    expect(find.textContaining('Ordi 1 : 20 ('), findsOneWidget);
    expect(find.text('Ordi +20'), findsOneWidget);

    await tester.tap(find.text('Annonces'));
    expect(controller.dismissedRecap, isTrue);

    controller.show(tableOf(game, recapFor: [2]));
    await tester.pump();
    expect(find.text('Annonces'), findsNothing);
    expect(find.text('Bea lit les annonces…'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('a played card slides in, cards already played stay put', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    game.apply(PlayCard(0, Card.parse('SA')));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    await tester.pump(const Duration(milliseconds: 300));

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
    await tester.pump(const Duration(milliseconds: 300));
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
        name: tester.getRect(find.textContaining(RegExp('^$name( •)?\$'))).top,
      'scores': tester.getRect(find.byType(ScoreBoard)).height,
    };
    final choosing = layout(); // Trump buttons in the action area.

    game.apply(const ChooseTrump(0, TrumpMode.hearts));
    controller.show(tableOf(game));
    await tester.pump();
    expect(layout(), choosing); // Meld buttons, trump in the score bar.

    await tester.tap(find.bySemanticsLabel('7 de cœur'));
    await tester.pump();
    expect(layout(), choosing);
    await tester.tap(find.text('Valider l\'annonce'));
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
    final hand = CardSet.parse('D7 H6 H7 H8 H9 H10 HJ HQ HK');
    final rest = (CardSet.full - hand).cards;
    final game = GameState(
      options: const GameOptions(),
      deals: ReplayDealSource([
        [
          hand,
          for (var seat = 0; seat < 3; seat++)
            CardSet.of(rest.sublist(seat * 9, seat * 9 + 9)),
        ],
      ]),
    )..apply(const ChooseTrump(0, TrumpMode.hearts));
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
    expect(game.viewFor(0).legalCards.contains(king), isTrue);
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    await tester.pump(const Duration(milliseconds: 300));

    final chip = tester.getCenter(find.text('Stöck'));
    final card = tester.getRect(find.bySemanticsLabel('roi de cœur'));
    expect(chip.dy, lessThan(card.top));
    await tester.tap(find.text('Stöck'));
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
    expect(find.text('Ana : Stöck'), findsOneWidget);
    expect(find.text('Nous +20'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('"Jouer pour moi" plays the suggestion, keeping meld choices', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final controller = FakeController(tableOf(game))
      ..suggestion = PlayCard(
        0,
        Card.parse('SA'),
        melds: [Meld.fromCards(CardSet.parse('H6 H7 H8'))!],
      );
    await pumpScreen(tester, controller);
    await tester.tap(find.text('Ne pas annoncer, jouer'));
    await tester.pump();
    await tester.tap(find.text('Jouer pour moi'));
    await tester.pump();
    final play = controller.actions.single as PlayCard;
    expect(play.card, Card.parse('SA'));
    expect(play.melds, isEmpty); // The player chose not to announce.
  });

  testWidgets('"Cartes jouées" shows the announcements and cards by suit', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.hearts));
    final sequence = Meld.fromCards(CardSet.parse('H6 H7 H8'))!;
    game.apply(PlayCard(0, Card.parse('SA'), melds: [sequence]));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);
    await tester.tap(find.text('Cartes jouées'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Ana : 20 ('), findsOneWidget);
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
    expect(find.text('Jouer pour moi'), findsNothing);
    expect(find.text('Cartes jouées'), findsNothing);
  });
}
