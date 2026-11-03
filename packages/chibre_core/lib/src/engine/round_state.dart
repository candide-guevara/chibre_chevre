import 'card.dart';
import 'card_set.dart';
import 'card_values.dart';
import 'deal.dart';
import 'game_action.dart';
import 'game_options.dart';
import 'illegal_action_exception.dart';
import 'legal_moves.dart';
import 'meld.dart';
import 'meld_comparison.dart';
import 'meld_validator.dart';
import 'score_entry.dart';
import 'seat.dart';
import 'stoeck.dart';
import 'trick.dart';
import 'trump_mode.dart';

enum RoundPhase { choosingTrump, playing, over }

/// One deal: the trump choice, the melds and the nine tricks.
class RoundState {
  RoundState({
    required this.options,
    required List<CardSet> deal,
    required this.trumpChooser,
  })  : initialHands = List.unmodifiable(deal),
        _hands = List.of(deal);

  final GameOptions options;
  final List<CardSet> initialHands;

  /// The seat that must choose trump (or chibrer). It leads the first trick.
  final int trumpChooser;

  final List<CardSet> _hands;
  var _chibred = false;
  TrumpMode? _mode;
  Trick? _currentTrick;
  final _tricks = <Trick>[];
  final _melds = List<List<Meld>>.filled(seatCount, const []);
  int? _meldWinningTeam;
  int? _stoeckSeat;
  final _points = [0, 0];
  final _tricksWon = [0, 0];

  RoundPhase get phase {
    if (_mode == null) return RoundPhase.choosingTrump;
    if (_tricks.length == tricksPerRound) return RoundPhase.over;
    return RoundPhase.playing;
  }

  int get seatToAct => switch (phase) {
        RoundPhase.choosingTrump =>
          _chibred ? partnerOf(trumpChooser) : trumpChooser,
        RoundPhase.playing => _currentTrick!.nextSeat,
        RoundPhase.over => throw StateError('The round is over'),
      };

  bool get chibred => _chibred;

  TrumpMode? get mode => _mode;

  int get multiplier => options.multiplierFor(_mode!);

  CardSet handOf(int seat) => _hands[seat];

  CardSet playedBy(int seat) => initialHands[seat] - _hands[seat];

  Trick? get currentTrick => _currentTrick;

  List<Trick> get completedTricks => List.unmodifiable(_tricks);

  /// The melds announced by [seat] (all players see their values).
  List<Meld> meldsOf(int seat) => _melds[seat];

  /// The team whose melds counted, once the first trick is over.
  int? get meldWinningTeam => _meldWinningTeam;

  int? get stoeckSeat => _stoeckSeat;

  /// Points scored by each team this round, multiplier included.
  List<int> get points => List.unmodifiable(_points);

  List<int> get tricksWon => List.unmodifiable(_tricksWon);

  CardSet get legalCards =>
      legalMoves(_hands[seatToAct], _currentTrick!.cards, _mode!);

  bool canAnnounceStoeck(int seat, Card card) =>
      _mode != null &&
      _stoeckSeat == null &&
      completesStoeck(card, playedBy(seat), _mode!);

  /// Applies [action] and returns the points it scored, in counting order.
  List<ScoreEntry> apply(GameAction action) {
    final error = validate(action);
    if (error != null) throw IllegalActionException(error);
    return switch (action) {
      Chibrer() => _chibrer(),
      ChooseTrump(:final mode) => _chooseTrump(mode),
      PlayCard() => _play(action),
    };
  }

  /// Why [action] is not allowed, or null if it is.
  String? validate(GameAction action) {
    if (phase == RoundPhase.over) return 'The round is over';
    if (action.seat != seatToAct) {
      return 'It is not seat ${action.seat}\'s turn';
    }
    switch (action) {
      case Chibrer():
        if (phase != RoundPhase.choosingTrump) return 'Trump is already chosen';
        if (_chibred) return 'The trump choice was already passed';
        return null;
      case ChooseTrump(:final mode):
        if (phase != RoundPhase.choosingTrump) return 'Trump is already chosen';
        if (!options.allowedModes.contains(mode)) return '$mode is not allowed';
        return null;
      case PlayCard():
        return _validatePlay(action);
    }
  }

  String? _validatePlay(PlayCard action) {
    if (phase != RoundPhase.playing) return 'Trump is not chosen yet';
    final hand = _hands[action.seat];
    if (!hand.contains(action.card)) return '${action.card} is not in hand';
    if (!legalCards.contains(action.card)) {
      return '${action.card} cannot be played now';
    }
    if (action.melds.isNotEmpty) {
      if (_tricks.isNotEmpty) {
        return 'Melds are only allowed in the first trick';
      }
      final error = validateMelds(action.melds, hand);
      if (error != null) return 'Invalid melds: ${error.name}';
    }
    if (action.stoeck && !canAnnounceStoeck(action.seat, action.card)) {
      return 'Stöck cannot be announced with ${action.card}';
    }
    return null;
  }

  List<ScoreEntry> _chibrer() {
    _chibred = true;
    return const [];
  }

  List<ScoreEntry> _chooseTrump(TrumpMode mode) {
    _mode = mode;
    _currentTrick = Trick(trumpChooser);
    return const [];
  }

  List<ScoreEntry> _play(PlayCard action) {
    final seat = action.seat;
    if (action.melds.isNotEmpty) _melds[seat] = List.unmodifiable(action.melds);
    _hands[seat] = _hands[seat].remove(action.card);
    final trick = _currentTrick!..cards.add(action.card);
    final entries = <ScoreEntry>[];
    if (action.stoeck) {
      _stoeckSeat = seat;
      entries.add(_score(teamOf(seat), stoeckPoints, ScoreReason.stoeck));
    }
    if (trick.isComplete) entries.addAll(_completeTrick(trick));
    return entries;
  }

  List<ScoreEntry> _completeTrick(Trick trick) {
    final entries = <ScoreEntry>[];
    if (_tricks.isEmpty) {
      _meldWinningTeam = winningMeldTeam(_melds, _mode!, trick.leader);
      if (_meldWinningTeam != null) {
        final points = teamMeldPoints(_melds, _meldWinningTeam!);
        entries.add(_score(_meldWinningTeam!, points, ScoreReason.melds));
      }
    }

    final winner = trick.winner(_mode!);
    final team = teamOf(winner);
    _tricks.add(trick);
    _tricksWon[team]++;
    var points = trick.points(_mode!);
    if (_tricks.length == tricksPerRound) {
      points += lastTrickBonus;
      if (_tricksWon[team] == tricksPerRound) points += matchBonus;
      _currentTrick = null;
    } else {
      _currentTrick = Trick(winner);
    }
    entries.add(_score(team, points, ScoreReason.trick));
    return entries;
  }

  ScoreEntry _score(int team, int points, ScoreReason reason) {
    final total = points * multiplier;
    _points[team] += total;
    return ScoreEntry(team, total, reason);
  }
}
