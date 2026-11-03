import 'card_set.dart';
import 'game_action.dart';
import 'game_options.dart';

/// Everything needed to replay a round: the deal and the actions in order.
class RoundRecord {
  RoundRecord({required this.deal, required this.trumpChooser});

  final List<CardSet> deal;
  final int trumpChooser;
  final List<GameAction> actions = [];
}

/// The full history of a game, used for the insights and for rematches with
/// the same cards.
class GameRecord {
  GameRecord(this.options);

  final GameOptions options;
  final List<RoundRecord> rounds = [];

  List<List<CardSet>> get deals => [for (final round in rounds) round.deal];
}
