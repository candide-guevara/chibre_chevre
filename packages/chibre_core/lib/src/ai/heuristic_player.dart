import '../engine/card_set.dart';
import '../engine/game_action.dart';
import '../engine/player_view.dart';
import 'computer_player.dart';
import 'heuristic_policy.dart';
import 'trump_heuristic.dart';

/// Plays by rules of thumb, without any search. A baseline for the expert.
class HeuristicPlayer extends ComputerPlayer {
  @override
  GameAction decideTrump(PlayerView view) {
    final allowed = view.options.allowedModes;
    final mode = bestHeuristicMode(view.hand, allowed);
    if (!view.chibred && handStrength(view.hand, mode) < chibrerThreshold) {
      return Chibrer(view.seat);
    }
    return ChooseTrump(view.seat, mode);
  }

  @override
  PlayCard decidePlay(PlayerView view) {
    final card = heuristicCard(view.hand, view.currentTrick!.cards, view.mode!,
        CardSet.full - view.playedCards);
    return playWithAnnouncements(view, card);
  }
}
