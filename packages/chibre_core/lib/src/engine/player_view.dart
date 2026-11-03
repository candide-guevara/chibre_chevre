import 'card_set.dart';
import 'deal.dart';
import 'game_options.dart';
import 'legal_moves.dart';
import 'meld.dart';
import 'round_state.dart';
import 'seat.dart';
import 'trick.dart';
import 'trump_mode.dart';

/// What one seat is allowed to know about the current round. Computer players
/// decide from this only, so they can't peek at other hands.
class PlayerView {
  PlayerView({
    required this.seat,
    required this.options,
    required this.hand,
    required this.mode,
    required this.trumpChooser,
    required this.chibred,
    required this.completedTricks,
    required this.currentTrick,
    required this.announcedMeldValues,
    required this.revealedMelds,
    required this.stoeckSeat,
    required this.scores,
  });

  factory PlayerView.ofRound(RoundState round, int seat,
      {List<int> scores = const [0, 0]}) {
    final revealed = round.meldWinningTeam;
    return PlayerView(
      seat: seat,
      options: round.options,
      hand: round.handOf(seat),
      mode: round.mode,
      trumpChooser: round.trumpChooser,
      chibred: round.chibred,
      completedTricks: [
        for (final trick in round.completedTricks) trick.copy()
      ],
      currentTrick: round.currentTrick?.copy(),
      announcedMeldValues: [
        for (var s = 0; s < seatCount; s++)
          [for (final meld in round.meldsOf(s)) meld.value],
      ],
      revealedMelds: [
        for (var s = 0; s < seatCount; s++)
          teamOf(s) == revealed || s == seat ? round.meldsOf(s) : const [],
      ],
      stoeckSeat: round.stoeckSeat,
      scores: List.unmodifiable(scores),
    );
  }

  final int seat;
  final GameOptions options;
  final CardSet hand;

  /// Null while trump is being chosen.
  final TrumpMode? mode;
  final int trumpChooser;
  final bool chibred;
  final List<Trick> completedTricks;

  /// Null while trump is being chosen and once the round is over.
  final Trick? currentTrick;

  /// The value of each meld announced, by seat.
  final List<List<int>> announcedMeldValues;

  /// The cards of the melds that were shown, by seat: the player's own melds
  /// and, after the first trick, those of the team whose melds counted.
  final List<List<Meld>> revealedMelds;

  final int? stoeckSeat;

  /// Game scores by team.
  final List<int> scores;

  int get multiplier => options.multiplierFor(mode!);

  bool get isFirstTrick => completedTricks.isEmpty;

  bool get mayAnnounceMelds =>
      mode != null && isFirstTrick && announcedMeldValues[seat].isEmpty;

  CardSet get legalCards => legalMoves(hand, currentTrick!.cards, mode!);

  /// All cards played this round, current trick included.
  CardSet get playedCards {
    var played = CardSet.empty;
    for (final trick in allTricks) {
      played = played | CardSet.of(trick.cards);
    }
    return played;
  }

  CardSet playedBy(int seat) {
    var played = CardSet.empty;
    for (final trick in allTricks) {
      final card = trick.cardOf(seat);
      if (card != null) played = played.add(card);
    }
    return played;
  }

  /// Completed tricks followed by the current one.
  List<Trick> get allTricks =>
      [...completedTricks, if (currentTrick != null) currentTrick!];

  int handSizeOf(int seat) => handSize - playedBy(seat).length;

  /// Tricks won so far by each team.
  List<int> get tricksWon {
    final won = [0, 0];
    for (final trick in completedTricks) {
      won[teamOf(trick.winner(mode!))]++;
    }
    return won;
  }
}
