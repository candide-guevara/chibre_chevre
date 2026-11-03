import '../ai/computer_player.dart';
import '../engine/card_set.dart';
import '../engine/deal_source.dart';
import '../engine/game_options.dart';
import '../engine/game_state.dart';
import '../engine/player_view.dart';
import '../engine/round_state.dart';

/// Plays games or single rounds between computer players, one per seat.
class MatchRunner {
  const MatchRunner(this.players, {this.options = const GameOptions()});

  final List<ComputerPlayer> players;
  final GameOptions options;

  GameState playGame({DealSource? deals}) {
    final game = GameState(options: options, deals: deals);
    while (game.phase != GamePhase.gameOver) {
      if (game.phase == GamePhase.roundOver) {
        game.startNextRound();
        continue;
      }
      final seat = game.seatToAct;
      game.apply(players[seat].decide(game.viewFor(seat)));
    }
    return game;
  }

  /// Plays [deal] to the end and returns the finished round.
  RoundState playRound(List<CardSet> deal, {required int trumpChooser}) {
    final round =
        RoundState(options: options, deal: deal, trumpChooser: trumpChooser);
    while (round.phase != RoundPhase.over) {
      final seat = round.seatToAct;
      round.apply(players[seat].decide(PlayerView.ofRound(round, seat)));
    }
    return round;
  }
}
