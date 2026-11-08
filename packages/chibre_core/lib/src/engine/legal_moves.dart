import 'card.dart';
import 'card_set.dart';
import 'card_values.dart';
import 'trump_mode.dart';

/// The cards of [hand] that may be played on [trick].
///
/// Swiss rules: follow suit if possible, but trumping is always allowed.
/// The jack of trump never has to be played to follow trump. Undertrumping is
/// forbidden unless the hand holds nothing but trumps.
CardSet legalMoves(CardSet hand, List<Card> trick, TrumpMode mode) {
  if (trick.isEmpty) return hand;
  final led = trick.first.suit;
  final following = hand.ofSuit(led);
  final trump = mode.trumpSuit;
  if (trump == null) return following.isEmpty ? hand : following;

  final trumps = hand.ofSuit(trump);
  if (led == trump) {
    final withoutJack = following.remove(Card(trump, Rank.jack));
    return withoutJack.isEmpty ? hand : following;
  }

  final allowed = following.isEmpty ? hand : following | trumps;
  if (trumps == hand) return allowed;
  return allowed - _undertrumps(trumps, trick, mode);
}

CardSet _undertrumps(CardSet trumps, List<Card> trick, TrumpMode mode) {
  Card? best;
  for (final card in trick) {
    if (card.suit == mode.trumpSuit &&
        (best == null || suitStrength(card, mode) > suitStrength(best, mode))) {
      best = card;
    }
  }
  return best == null ? CardSet.empty : weakerInSuit(best, trumps, mode);
}
