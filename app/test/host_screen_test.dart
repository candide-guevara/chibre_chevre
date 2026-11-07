import 'dart:typed_data';

import 'package:chibre/screens/host_screen.dart';
import 'package:chibre/services/app_services.dart';
import 'package:chibre/services/profile_store.dart';
import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoSavedGame implements SavedGameStore {
  @override
  Future<Uint8List?> load() async => null;

  @override
  Future<void> save(Uint8List bytes) async {}

  @override
  Future<void> clear() async {}
}

void main() {
  testWidgets('the game defaults are saved from the host screen', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final profile = await ProfileStore.open();
    await tester.pumpWidget(
      Services(
        services: AppServices.forTesting(
          profile: profile,
          savedGames: NoSavedGame(),
        ),
        child: MaterialApp(
          theme: chibreTheme(),
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const HostScreen(editingDefaults: true),
                ),
              ),
              child: const Text('Profil'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Nom de la partie'), findsNothing);

    await tester.enterText(find.byType(TextField), '1500');
    await tester.tap(find.text('Multiplicateurs'));
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.byType(HostScreen), findsNothing);
    expect(profile.gameDefaults.options.targetScore, 1500);
    expect(profile.gameDefaults.options.multipliersEnabled, isTrue);
  });
}
