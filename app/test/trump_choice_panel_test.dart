import 'package:chibre/strings.dart';
import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre/widgets/trump_choice_panel.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Obenabe and Undenufe share the row of the suits', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(412, 906);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: chibreTheme(),
        home: Scaffold(
          body: SizedBox(
            height: 100,
            child: TrumpChoicePanel(
              modes: TrumpMode.values,
              canChibrer: true,
              onChoose: (_) {},
              onChibrer: () {},
            ),
          ),
        ),
      ),
    );
    final rows = {
      for (final mode in TrumpMode.values)
        tester.getCenter(find.bySemanticsLabel(Strings.modeName(mode))).dy,
    };
    expect(rows, hasLength(1));
    expect(
      tester.getCenter(find.text(Strings.chibrer)).dy,
      greaterThan(rows.single),
    );
  });
}
