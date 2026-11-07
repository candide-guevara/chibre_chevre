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
}
