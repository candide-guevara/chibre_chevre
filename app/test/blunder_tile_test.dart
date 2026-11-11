import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre/widgets/blunder_tile.dart';
import 'package:chibre/widgets/card_label.dart';
import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:chibre_core/chibre_core.dart' as core show Card;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cards are written as rank and suit', (tester) async {
    final blunder = Blunder(
      kind: BlunderKind.cardPlay,
      seat: 0,
      roundIndex: 0,
      trickIndex: 2,
      hand: CardSet.parse('C7 CK H10'),
      trick: [core.Card.parse('SA')],
      mode: TrumpMode.hearts,
      pointsLost: 12,
      playedCard: core.Card.parse('CK'),
      bestCard: core.Card.parse('C7'),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: chibreTheme(),
        home: Scaffold(body: BlunderTile(blunder: blunder, sortByTrump: false)),
      ),
    );
    // 3 in the hand, 1 on the table, 2 in the explanation.
    expect(find.byType(CardLabel), findsNWidgets(6));
    expect(find.text('K'), findsNWidgets(2));
    expect(find.textContaining('Mieux', findRichText: true), findsOneWidget);
    expect(find.textContaining('trèfle', findRichText: true), findsNothing);
  });

  testWidgets('the trump is shown, and omitted for a trump choice', (
    tester,
  ) async {
    Future<void> show(Blunder blunder) => tester.pumpWidget(
      MaterialApp(
        theme: chibreTheme(),
        home: Scaffold(body: BlunderTile(blunder: blunder, sortByTrump: false)),
      ),
    );
    Blunder cardPlay(TrumpMode mode) => Blunder(
      kind: BlunderKind.cardPlay,
      seat: 0,
      roundIndex: 0,
      trickIndex: 0,
      hand: CardSet.parse('C7 CK'),
      trick: const [],
      mode: mode,
      pointsLost: 5,
      playedCard: core.Card.parse('CK'),
      bestCard: core.Card.parse('C7'),
    );

    await show(cardPlay(TrumpMode.hearts));
    expect(find.text('Atout'), findsOneWidget);
    expect(find.text('♥ cœur'), findsOneWidget);

    await show(cardPlay(TrumpMode.obenabe));
    expect(find.text('⬇ Obenabe'), findsOneWidget);

    await show(
      Blunder(
        kind: BlunderKind.trumpChoice,
        seat: 0,
        roundIndex: 0,
        trickIndex: null,
        hand: CardSet.parse('C7 CK'),
        trick: const [],
        mode: null,
        pointsLost: 5,
        chosenTrump: TrumpOption.mode(TrumpMode.hearts),
        bestTrump: TrumpOption.mode(TrumpMode.obenabe),
      ),
    );
    expect(find.text('Atout'), findsNothing);
  });
}
