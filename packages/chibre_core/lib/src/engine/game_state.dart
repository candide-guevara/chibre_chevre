import 'card.dart';
import 'card_set.dart';
import 'deal.dart';
import 'deal_source.dart';
import 'game_action.dart';
import 'game_options.dart';
import 'game_record.dart';
import 'illegal_action_exception.dart';
import 'player_view.dart';
import 'random_deal_source.dart';
import 'replay_deal_source.dart';
import 'round_state.dart';
import 'score_entry.dart';
import 'seat.dart';

enum GamePhase { choosingTrump, playing, roundOver, gameOver }

/// A whole game: rounds are played until a team reaches the target score.
class GameState {
  GameState({required this.options, DealSource? deals})
      : _deals = deals ?? RandomDealSource(),
        record = GameRecord(options) {
    final deal = _deals.nextDeal();
    _startRound(deal, holderOf(Card(Suit.diamonds, Rank.seven), deal));
  }

  /// A new game dealt exactly like [record], ready to replay its actions.
  factory GameState.replaying(GameRecord record, {DealSource? fallback}) =>
      GameState(
        options: record.options,
        deals: ReplayDealSource(record.deals, fallback: fallback),
      );

  final GameOptions options;
  final GameRecord record;
  final DealSource _deals;
  final _scores = [0, 0];
  late RoundState _round;
  int? _winningTeam;

  GamePhase get phase {
    if (_winningTeam != null) return GamePhase.gameOver;
    return switch (_round.phase) {
      RoundPhase.choosingTrump => GamePhase.choosingTrump,
      RoundPhase.playing => GamePhase.playing,
      RoundPhase.over => GamePhase.roundOver,
    };
  }

  RoundState get round => _round;

  /// Zero-based index of the current round.
  int get roundIndex => record.rounds.length - 1;

  int get seatToAct => _round.seatToAct;

  List<int> get scores => List.unmodifiable(_scores);

  int? get winningTeam => _winningTeam;

  PlayerView viewFor(int seat) =>
      PlayerView.ofRound(_round, seat, scores: _scores);

  /// Applies [action] and returns the points that were added to the scores.
  /// Points are counted one entry at a time, so the game can end mid-round.
  List<ScoreEntry> apply(GameAction action) {
    if (phase == GamePhase.gameOver) {
      throw const IllegalActionException('The game is over');
    }
    final entries = _round.apply(action);
    record.rounds.last.actions.add(action);
    final counted = <ScoreEntry>[];
    for (final entry in entries) {
      _scores[entry.team] += entry.points;
      counted.add(entry);
      if (_scores[entry.team] >= options.targetScore) {
        _winningTeam = entry.team;
        break;
      }
    }
    return counted;
  }

  /// Deals the next round; the trump choice moves to the next seat.
  void startNextRound() {
    if (phase != GamePhase.roundOver) {
      throw StateError('The current round is not over');
    }
    _startRound(_deals.nextDeal(), nextSeat(_round.trumpChooser));
  }

  void _startRound(List<CardSet> deal, int trumpChooser) {
    _round =
        RoundState(options: options, deal: deal, trumpChooser: trumpChooser);
    record.rounds.add(RoundRecord(deal: deal, trumpChooser: trumpChooser));
  }
}
