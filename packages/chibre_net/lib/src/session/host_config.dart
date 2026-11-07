import 'package:chibre_core/chibre_core.dart';

/// What the host chose on the host game screen.
class HostConfig {
  const HostConfig({
    required this.gameName,
    required this.nickname,
    this.options = const GameOptions(),
    this.trickHold = defaultTrickHold,
    this.assistance = false,
  });

  static const defaultTrickHold = Duration(milliseconds: 1500);

  final String gameName;
  final String nickname;
  final GameOptions options;

  /// How long a complete trick stays on the table before sliding to its
  /// winner, so that beginners can memorize the cards played.
  final Duration trickHold;

  /// Whether the players get the "Jouer pour moi" and "Cartes jouées"
  /// buttons.
  final bool assistance;
}
