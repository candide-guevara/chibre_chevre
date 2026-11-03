import 'card_set.dart';
import 'meld.dart';

enum MeldError {
  /// A meld uses a card the player doesn't hold.
  notInHand,

  /// Two sequences share a card, or a meld is announced twice.
  overlapping,
}

/// Checks the melds a player announces together. A card may belong to both a
/// sequence and a four of a kind, but not to two sequences.
MeldError? validateMelds(List<Meld> melds, CardSet hand) {
  var inSequences = CardSet.empty;
  final seen = <Meld>{};
  for (final meld in melds) {
    if (!hand.containsAll(meld.cards)) return MeldError.notInHand;
    if (!seen.add(meld)) return MeldError.overlapping;
    if (meld.kind == MeldKind.sequence) {
      if ((inSequences & meld.cards).isNotEmpty) return MeldError.overlapping;
      inSequences = inSequences | meld.cards;
    }
  }
  return null;
}
