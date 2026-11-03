import 'dart:math';

import '../engine/game_action.dart';
import '../engine/player_view.dart';
import 'computer_player.dart';

/// Plays random legal cards. A baseline to measure the other players.
class RandomPlayer extends ComputerPlayer {
  RandomPlayer([Random? random]) : _random = random ?? Random();

  final Random _random;

  @override
  GameAction decideTrump(PlayerView view) {
    final modes = view.options.allowedModes;
    return ChooseTrump(view.seat, modes[_random.nextInt(modes.length)]);
  }

  @override
  PlayCard decidePlay(PlayerView view) {
    final legal = view.legalCards.cards;
    return playWithAnnouncements(view, legal[_random.nextInt(legal.length)]);
  }
}
