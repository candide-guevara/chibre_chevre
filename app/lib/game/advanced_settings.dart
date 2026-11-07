import 'package:chibre_net/chibre_net.dart';

/// The options of the advanced settings screen.
class AdvancedSettings {
  const AdvancedSettings({
    this.trickHold = HostConfig.defaultTrickHold,
    this.assistance = false,
    this.sortByTrump = false,
  });

  /// How long a complete trick stays before sliding to its winner.
  final Duration trickHold;

  /// Whether the play screen shows "Jouer pour moi" and "Cartes jouées".
  final bool assistance;

  /// Whether hands are sorted by trump rather than in a fixed suit order.
  final bool sortByTrump;

  AdvancedSettings copyWith({
    Duration? trickHold,
    bool? assistance,
    bool? sortByTrump,
  }) => AdvancedSettings(
    trickHold: trickHold ?? this.trickHold,
    assistance: assistance ?? this.assistance,
    sortByTrump: sortByTrump ?? this.sortByTrump,
  );
}
