import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';

/// What the play, end and insights screens need from a game, whether this
/// phone hosts it or joined it.
abstract interface class GameController {
  Stream<TableView> get tables;

  TableView? get table;

  void act(GameAction action);

  /// The move the expert computer player would make in this player's place,
  /// from what this player can see only.
  Future<GameAction> suggestAction();

  void proposeRematch({required bool sameCards});

  void answerRematch({required bool accept});

  /// The player chose their melds (sent with the first card), or not to
  /// announce any; the computer players wait for it.
  void meldsChosen();

  /// The player closed the meld recap.
  void dismissRecap();

  /// The app went to the background (or came back).
  void setAway(bool away);

  /// Leaves the game for good, ending it for the other player too.
  Future<void> leave();
}
