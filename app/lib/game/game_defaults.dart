import 'package:chibre_core/chibre_core.dart';

import 'advanced_settings.dart';

/// The options the host screen starts with, configured from the profile.
class GameDefaults {
  const GameDefaults({
    this.options = const GameOptions(),
    this.advanced = const AdvancedSettings(),
  });

  final GameOptions options;
  final AdvancedSettings advanced;

  Map<String, Object> toJson() => {
    'targetScore': options.targetScore,
    'obenUndeAllowed': options.obenUndeAllowed,
    'multipliersEnabled': options.multipliersEnabled,
    'trickHoldMs': advanced.trickHold.inMilliseconds,
    'assistance': advanced.assistance,
    'sortByTrump': advanced.sortByTrump,
    'autoAnnounce': advanced.autoAnnounce,
    'thinkingTimeMs': advanced.thinkingTime.inMilliseconds,
  };

  /// Missing or malformed values keep their default.
  factory GameDefaults.fromJson(Map<String, Object?> json) {
    const defaults = GameDefaults();
    T read<T>(String key, T fallback) => switch (json[key]) {
      final T value => value,
      _ => fallback,
    };
    return GameDefaults(
      options: GameOptions(
        targetScore: read('targetScore', defaults.options.targetScore),
        obenUndeAllowed: read(
          'obenUndeAllowed',
          defaults.options.obenUndeAllowed,
        ),
        multipliersEnabled: read(
          'multipliersEnabled',
          defaults.options.multipliersEnabled,
        ),
      ),
      advanced: AdvancedSettings(
        trickHold: Duration(
          milliseconds: read(
            'trickHoldMs',
            defaults.advanced.trickHold.inMilliseconds,
          ),
        ),
        assistance: read('assistance', defaults.advanced.assistance),
        sortByTrump: read('sortByTrump', defaults.advanced.sortByTrump),
        autoAnnounce: read('autoAnnounce', defaults.advanced.autoAnnounce),
        thinkingTime: Duration(
          milliseconds: read(
            'thinkingTimeMs',
            defaults.advanced.thinkingTime.inMilliseconds,
          ),
        ),
      ),
    );
  }
}
