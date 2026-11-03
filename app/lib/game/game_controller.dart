import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';

/// What the play, end and insights screens need from a game, whether this
/// phone hosts it or joined it.
abstract interface class GameController {
  Stream<TableView> get tables;

  TableView? get table;

  void act(GameAction action);

  void proposeRematch({required bool sameCards});

  void answerRematch({required bool accept});

  /// The app went to the background (or came back).
  void setAway(bool away);

  /// Leaves the game for good, ending it for the other player too.
  Future<void> leave();
}
