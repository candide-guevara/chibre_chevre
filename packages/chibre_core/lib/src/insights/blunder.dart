import '../ai/trump_option.dart';
import '../engine/card.dart';
import '../engine/card_set.dart';
import '../engine/meld.dart';
import '../engine/trump_mode.dart';

enum BlunderKind { trumpChoice, cardPlay, missedMeld, missedStoeck }

/// A human decision that cost points, with the situation it was made in.
class Blunder {
  const Blunder({
    required this.kind,
    required this.seat,
    required this.roundIndex,
    required this.trickIndex,
    required this.hand,
    required this.trick,
    required this.mode,
    required this.pointsLost,
    this.playedCard,
    this.bestCard,
    this.chosenTrump,
    this.bestTrump,
    this.missedMelds = const [],
  });

  final BlunderKind kind;
  final int seat;
  final int roundIndex;

  /// Null for a trump choice.
  final int? trickIndex;

  /// The player's hand before the decision.
  final CardSet hand;

  /// The cards already on the table in the current trick.
  final List<Card> trick;

  /// Null for a trump choice.
  final TrumpMode? mode;

  /// Expected points lost by the player's team, multiplier included.
  final double pointsLost;

  /// For [BlunderKind.cardPlay] and [BlunderKind.missedStoeck].
  final Card? playedCard;
  final Card? bestCard;

  /// For [BlunderKind.trumpChoice].
  final TrumpOption? chosenTrump;
  final TrumpOption? bestTrump;

  /// For [BlunderKind.missedMeld].
  final List<Meld> missedMelds;

  @override
  String toString() => 'Blunder(${kind.name}, seat $seat, round $roundIndex, '
      'trick $trickIndex, -${pointsLost.toStringAsFixed(1)} pts)';
}
