import 'package:chibre/game/advanced_settings.dart';
import 'package:chibre/screens/advanced_settings_screen.dart';
import 'package:chibre/theme/chibre_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('changes are reported to the host screen', (tester) async {
    AdvancedSettings? reported;
    await tester.pumpWidget(
      MaterialApp(
        theme: chibreTheme(),
        home: AdvancedSettingsScreen(
          settings: const AdvancedSettings(),
          onChanged: (settings) => reported = settings,
        ),
      ),
    );
    expect(find.text('Pause avant de ramasser un pli : 1,5 s'), findsOneWidget);
    await tester.tap(find.text('Aide de jeu'));
    await tester.pump();
    expect(reported!.assistance, isTrue);
    expect(reported!.trickHold, const Duration(milliseconds: 1500));
  });

  testWidgets('the computers think 0,6 s by default, from 0,2 to 2 s', (
    tester,
  ) async {
    AdvancedSettings? reported;
    await tester.pumpWidget(
      MaterialApp(
        theme: chibreTheme(),
        home: AdvancedSettingsScreen(
          settings: const AdvancedSettings(),
          onChanged: (settings) => reported = settings,
        ),
      ),
    );
    expect(find.text('Réflexion des ordinateurs : 0,6 s'), findsOneWidget);
    final slider = find.byType(Slider).at(1);
    await tester.drag(slider, const Offset(2000, 0));
    await tester.pump();
    expect(reported!.thinkingTime, const Duration(seconds: 2));
    expect(find.text('Réflexion des ordinateurs : 2,0 s'), findsOneWidget);
  });
}
