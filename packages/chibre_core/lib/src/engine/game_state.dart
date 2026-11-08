import 'card.dart';
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
    _startRound(RoundState(
        options: options,
        deal: deal,
        trumpChooser: holderOf(Card(Suit.diamonds, Rank.seven), deal)));
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

  /// The next round, once dealt ahead of time by [nextRoundViewFor].
  RoundState? _nextRound;

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

  /// The seat choosing trump in the next round.
  int get nextTrumpChooser => nextSeat(_round.trumpChooser);

  /// What [seat] will see when the next round starts, so that a computer
  /// player can think about it while the round summary is shown. Deals the
  /// next round, which [startNextRound] then starts.
  PlayerView nextRoundViewFor(int seat) =>
      PlayerView.ofRound(_dealNextRound(), seat, scores: _scores);

  /// Deals the next round, unless done already; the trump choice moves to
  /// the next seat.
  RoundState _dealNextRound() {
    if (phase != GamePhase.roundOver) {
      throw StateError('The current round is not over');
    }
    return _nextRound ??= RoundState(
        options: options,
        deal: _deals.nextDeal(),
        trumpChooser: nextTrumpChooser);
  }

  void startNextRound() {
    _startRound(_dealNextRound());
    _nextRound = null;
  }

  void _startRound(RoundState round) {
    _round = round;
    record.rounds.add(RoundRecord(
        deal: round.initialHands, trumpChooser: round.trumpChooser));
  }
}
