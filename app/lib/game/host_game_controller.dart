import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';

import 'game_controller.dart';

class HostGameController implements GameController {
  const HostGameController(this.session);

  final HostSession session;

  @override
  Stream<TableView> get tables => session.tables;

  @override
  TableView? get table => session.table;

  @override
  void act(GameAction action) => session.act(action);

  @override
  Future<GameAction> suggestAction() =>
      session.bots.decide(session.table!.player!);

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
  void dismissRoundSummary() => session.dismissRoundSummary();

  @override
  void setAway(bool away) => session.setAway(away);

  @override
  Future<void> leave() => session.close();
}
