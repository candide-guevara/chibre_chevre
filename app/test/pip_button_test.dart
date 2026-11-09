import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre/widgets/pip_button.dart';
import 'package:chibre/widgets/suit_icon.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the pips sit at both ends, the label in the middle', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: chibreTheme(),
        home: Center(
          child: SizedBox(
            width: 300,
            child: PipButton(
              suit: Suit.hearts,
              onPressed: () {},
              child: const Text('Jouer'),
            ),
          ),
        ),
      ),
    );
    final button = tester.getRect(find.byType(FilledButton));
    final pips = find.byType(SuitIcon);
    expect(pips, findsNWidgets(2));
    expect(tester.getRect(pips.first).left - button.left, 16);
    expect(button.right - tester.getRect(pips.last).right, 16);
    expect(tester.getCenter(find.text('Jouer')).dx, button.center.dx);
  });
}
