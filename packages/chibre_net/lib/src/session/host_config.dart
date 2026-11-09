import 'package:chibre_core/chibre_core.dart';

/// What the host chose on the host game screen.
class HostConfig {
  const HostConfig({
    required this.gameName,
    required this.nickname,
    this.options = const GameOptions(),
    this.trickHold = defaultTrickHold,
    this.assistance = false,
    this.sortByTrump = false,
    this.autoAnnounce = false,
    this.thinkingTime = defaultThinkingTime,
  });

  static const defaultTrickHold = Duration(milliseconds: 1500);
  static const defaultThinkingTime = Duration(milliseconds: 600);

  final String gameName;
  final String nickname;
  final GameOptions options;

  /// How long a complete trick stays on the table before sliding to its
  /// winner, so that beginners can memorize the cards played.
  final Duration trickHold;

  /// Whether the players get the "Jouer pour moi" and "Cartes jouées"
  /// buttons.
  final bool assistance;

  /// Whether hands are sorted by trump rather than in a fixed suit order.
  final bool sortByTrump;

  /// Whether Stöck is announced automatically and the melds are offered in
  /// a pop-up rather than selected card by card.
  final bool autoAnnounce;

  /// How long a computer player thinks per decision; also the budget of
  /// "Jouer pour moi".
  final Duration thinkingTime;
}
