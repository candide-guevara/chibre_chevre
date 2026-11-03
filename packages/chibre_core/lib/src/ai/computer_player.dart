import '../engine/card.dart';
import '../engine/game_action.dart';
import '../engine/meld_finder.dart';
import '../engine/player_view.dart';
import '../engine/stoeck.dart';

/// A computer controlled seat. It decides from its [PlayerView] only.
abstract class ComputerPlayer {
  /// Chooses trump or chibrer.
  GameAction decideTrump(PlayerView view);

  PlayCard decidePlay(PlayerView view);

  GameAction decide(PlayerView view) =>
      view.mode == null ? decideTrump(view) : decidePlay(view);
}

/// Plays [card], announcing every meld and the Stöck when possible.
PlayCard playWithAnnouncements(PlayerView view, Card card) => PlayCard(
      view.seat,
      card,
      melds: view.mayAnnounceMelds ? findBestMelds(view.hand) : const [],
      stoeck: view.stoeckSeat == null &&
          completesStoeck(card, view.playedBy(view.seat), view.mode!),
    );
