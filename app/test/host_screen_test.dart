import 'dart:typed_data';

import 'package:chibre/screens/host_screen.dart';
import 'package:chibre/services/app_services.dart';
import 'package:chibre/services/profile_store.dart';
import 'package:chibre/strings.dart';
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
    expect(find.text(Strings.gameName), findsNothing);

    await tester.enterText(find.byType(TextField), '1500');
    await tester.tap(find.text(Strings.multipliers));
    await tester.ensureVisible(find.text(Strings.finishLastRound));
    await tester.tap(find.text(Strings.finishLastRound));
    await tester.tap(find.text(Strings.save));
    await tester.pumpAndSettle();

    expect(find.byType(HostScreen), findsNothing);
    expect(profile.gameDefaults.options.targetScore, 1500);
    expect(profile.gameDefaults.options.multipliersEnabled, isTrue);
    expect(profile.gameDefaults.options.finishLastRound, isTrue);
  });

  testWidgets('a single player game needs no name', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final profile = await ProfileStore.open();
    await profile.setNickname('Ana');
    await tester.pumpWidget(
      Services(
        services: AppServices.forTesting(
          profile: profile,
          savedGames: NoSavedGame(),
        ),
        child: MaterialApp(
          theme: chibreTheme(),
          home: const HostScreen(solo: true),
        ),
      ),
    );
    expect(find.text(Strings.playAlone), findsOneWidget);
    expect(find.text(Strings.gameName), findsNothing);
    expect(find.text(Strings.startGame), findsOneWidget);
  });
}
