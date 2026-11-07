import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';

import 'game_controller.dart';

class ClientGameController implements GameController {
  const ClientGameController(this.session);

  final ClientSession session;

  @override
  Stream<TableView> get tables => session.tables;

  @override
  TableView? get table => session.table;

  @override
  void act(GameAction action) => session.act(action);

  @override
  void proposeRematch({required bool sameCards}) =>
      session.proposeRematch(sameCards: sameCards);

  @override
  void answerRematch({required bool accept}) =>
      session.answerRematch(accept: accept);

  @override
  void meldsChosen() => session.meldsChosen();

  @override
  void dismissRecap() => session.dismissRecap();

  @override
  void setAway(bool away) => session.setAway(away);

  @override
  Future<void> leave() => session.leave();
}
