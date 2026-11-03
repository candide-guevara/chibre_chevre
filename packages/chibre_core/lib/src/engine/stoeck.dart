import 'card.dart';
import 'card_set.dart';
import 'trump_mode.dart';

const stoeckPoints = 20;

/// Whether playing [card] completes the Stöck (king and queen of trump),
/// given the cards [alreadyPlayed] by the same player this round.
bool completesStoeck(Card card, CardSet alreadyPlayed, TrumpMode mode) {
  final trump = mode.trumpSuit;
  if (card.suit != trump) return false;
  final other = switch (card.rank) {
    Rank.king => Card(trump!, Rank.queen),
    Rank.queen => Card(trump!, Rank.king),
    _ => null,
  };
  return other != null && alreadyPlayed.contains(other);
}

/// Whether [hand] holds both the king and queen of trump.
bool holdsStoeck(CardSet hand, TrumpMode mode) {
  final trump = mode.trumpSuit;
  return trump != null &&
      hand.contains(Card(trump, Rank.king)) &&
      hand.contains(Card(trump, Rank.queen));
}
