import '../engine/card.dart';
import '../engine/card_set.dart';
import '../engine/card_values.dart';
import '../engine/deal.dart';
import '../engine/legal_moves.dart';
import '../engine/player_view.dart';
import '../engine/seat.dart';
import '../engine/trick.dart';
import '../engine/trump_mode.dart';

/// A fast simulation of the card play of a round where all hands are known.
/// The AI plays sampled deals to the end with it.
///
/// Melds and Stöck are ignored: once trump is chosen they don't depend on
/// how the cards are played.
class Playout {
  Playout({
    required this.hands,
    required this.mode,
    required this.leader,
    required this.trick,
    required this.tricksWon,
  });

  /// Continues the round seen in [view], with [hands] for all seats.
  factory Playout.fromView(PlayerView view, List<CardSet> hands) {
    final trick = view.currentTrick!;
    return Playout(
      hands: List.of(hands),
      mode: view.mode!,
      leader: trick.leader,
      trick: List.of(trick.cards),
      tricksWon: view.tricksWon,
    );
  }

  /// A copy of this playout with [hands] for all seats.
  Playout withHands(List<CardSet> hands) => Playout(
        hands: List.of(hands),
        mode: mode,
        leader: leader,
        trick: List.of(trick),
        tricksWon: List.of(tricksWon),
      );

  /// A round about to start, with [leader] playing first.
  factory Playout.newRound(List<CardSet> hands, TrumpMode mode, int leader) =>
      Playout(
        hands: List.of(hands),
        mode: mode,
        leader: leader,
        trick: [],
        tricksWon: [0, 0],
      );

  final List<CardSet> hands;
  final TrumpMode mode;
  int leader;
  final List<Card> trick;
  final List<int> tricksWon;

  /// Card points won by each team since the playout started.
  final points = [0, 0];

  bool get isOver => tricksWon[0] + tricksWon[1] == tricksPerRound;

  int get seatToAct => (leader + trick.length) % seatCount;

  CardSet get legalCards => legalMoves(hands[seatToAct], trick, mode);

  /// Cards still in someone's hand.
  CardSet get unplayed => hands[0] | hands[1] | hands[2] | hands[3];

  /// Half the point difference in favour of [team]: equivalent to the team's
  /// points when comparing alternatives.
  double advantage(int team) => (points[team] - points[opponentTeam(team)]) / 2;

  void play(Card card) {
    final seat = seatToAct;
    hands[seat] = hands[seat].remove(card);
    trick.add(card);
    if (trick.length < seatCount) return;

    final winner = (leader + winningIndex(trick, mode)) % seatCount;
    final team = teamOf(winner);
    var won = pointsOf(trick, mode);
    tricksWon[team]++;
    if (isOver) {
      won += lastTrickBonus;
      if (tricksWon[team] == tricksPerRound) won += matchBonus;
    }
    points[team] += won;
    trick.clear();
    leader = winner;
  }
}
