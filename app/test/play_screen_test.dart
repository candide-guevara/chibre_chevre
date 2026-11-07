import 'dart:async';

import 'package:chibre/game/game_controller.dart';
import 'package:chibre/screens/play_screen.dart';
import 'package:chibre/theme/chibre_theme.dart';
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

  @override
  void proposeRematch({required bool sameCards}) {}

  @override
  void answerRematch({required bool accept}) {}

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

TableView tableOf(GameState game, {int seat = 0}) => TableView(
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
    expect(find.text('À vous de jouer'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('as de pique'));
    expect((controller.actions.single as PlayCard).card, Card.parse('SA'));
  });

  testWidgets('melds are selected, validated and sent with the card', (
    tester,
  ) async {
    final game = newGame()..apply(const ChooseTrump(0, TrumpMode.clubs));
    final controller = FakeController(tableOf(game));
    await pumpScreen(tester, controller);

    await tester.tap(find.text('Annoncer'));
    await tester.pump();
    for (final name in ['6 de cœur', '8 de cœur']) {
      await tester.tap(find.bySemanticsLabel(name));
    }
    await tester.pump();
    await tester.tap(find.text('Valider'));
    await tester.pump();
    expect(find.text('Ces cartes ne forment pas une annonce.'), findsOneWidget);
    expect(controller.actions, isEmpty);

    await tester.tap(find.bySemanticsLabel('7 de cœur'));
    await tester.pump();
    await tester.tap(find.text('Valider'));
    await tester.pump();
    expect(find.textContaining('20 ('), findsOneWidget);

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
    expect(find.text('Ana joue…'), findsOneWidget);
    await tester.tap(find.text('Annoncer'));
    await tester.pump();
    expect(find.text('Valider'), findsOneWidget);
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
}
