import 'package:chibre/screens/profile_screen.dart';
import 'package:chibre/services/app_services.dart';
import 'package:chibre/services/profile_store.dart';
import 'package:chibre/theme/chibre_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'host_screen_test.dart';

void main() {
  testWidgets('the keyboard stays hidden until the nickname is tapped', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'nickname': 'Bea'});
    final services = AppServices.forTesting(
      profile: await ProfileStore.open(),
      savedGames: NoSavedGame(),
    );
    await tester.pumpWidget(
      Services(
        services: services,
        child: MaterialApp(theme: chibreTheme(), home: const ProfileScreen()),
      ),
    );
    await tester.pump();
    expect(tester.testTextInput.isVisible, isFalse);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);
  });

  testWidgets('the card design is chosen on the profile screen', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'nickname': 'Bea',
      'cardDesign': 'retired',
    });
    final profile = await ProfileStore.open();
    final services = AppServices.forTesting(
      profile: profile,
      savedGames: NoSavedGame(),
    );
    expect(services.cardDecks.value.id, 'vintage', reason: 'the default');
    await tester.pumpWidget(
      Services(
        services: services,
        child: MaterialApp(theme: chibreTheme(), home: const ProfileScreen()),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Vintage'));
    await tester.pump();
    expect(profile.cardDesign, 'retired', reason: 'not saved yet');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(services.cardDecks.value.id, 'vintage');
    expect(profile.cardDesign, 'vintage');
    expect(
      AppServices.forTesting(
        profile: profile,
        savedGames: NoSavedGame(),
      ).cardDecks.value.id,
      'vintage',
    );
  });
}
