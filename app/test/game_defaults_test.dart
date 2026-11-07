import 'package:chibre/game/advanced_settings.dart';
import 'package:chibre/game/game_defaults.dart';
import 'package:chibre/services/profile_store.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('the app\'s own defaults until the player saves some', () async {
    final store = await ProfileStore.open();
    final defaults = store.gameDefaults;
    expect(defaults.options.targetScore, 1000);
    expect(defaults.advanced.trickHold, const AdvancedSettings().trickHold);
  });

  test('saved defaults are kept on the phone', () async {
    final store = await ProfileStore.open();
    await store.setGameDefaults(
      const GameDefaults(
        options: GameOptions(
          targetScore: 1500,
          obenUndeAllowed: true,
          multipliersEnabled: true,
        ),
        advanced: AdvancedSettings(
          trickHold: Duration(seconds: 3),
          assistance: true,
          sortByTrump: true,
          autoAnnounce: true,
        ),
      ),
    );

    final defaults = (await ProfileStore.open()).gameDefaults;
    expect(defaults.options.targetScore, 1500);
    expect(defaults.options.obenUndeAllowed, isTrue);
    expect(defaults.options.multipliersEnabled, isTrue);
    expect(defaults.advanced.trickHold, const Duration(seconds: 3));
    expect(defaults.advanced.assistance, isTrue);
    expect(defaults.advanced.sortByTrump, isTrue);
    expect(defaults.advanced.autoAnnounce, isTrue);
  });

  test('profiles keep their own defaults', () async {
    await (await ProfileStore.open(profile: 'bea')).setGameDefaults(
      const GameDefaults(options: GameOptions(targetScore: 500)),
    );
    expect((await ProfileStore.open()).gameDefaults.options.targetScore, 1000);
  });

  test('missing or malformed values keep their default', () {
    final defaults = GameDefaults.fromJson({
      'targetScore': 2500,
      'assistance': 'yes',
    });
    expect(defaults.options.targetScore, 2500);
    expect(defaults.advanced.assistance, isFalse);
    expect(defaults.advanced.autoAnnounce, isFalse);
  });
}
