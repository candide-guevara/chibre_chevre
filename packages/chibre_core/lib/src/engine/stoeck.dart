import 'card.dart';
import 'card_set.dart';
import 'trick.dart';
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

/// The index, among [tricks], of the trick in which [stoeckSeat] announced
/// Stöck: the one where it played the second of the king and queen of trump.
/// Null if Stöck was not announced or that trick is not among [tricks].
int? stoeckTrickIndex(List<Trick> tricks, int? stoeckSeat, TrumpMode mode) {
  final trump = mode.trumpSuit;
  if (stoeckSeat == null || trump == null) return null;
  final pair = {Card(trump, Rank.king), Card(trump, Rank.queen)};
  var seen = 0;
  for (final (index, trick) in tricks.indexed) {
    for (final (position, card) in trick.cards.indexed) {
      if (trick.seatAt(position) == stoeckSeat && pair.contains(card)) seen++;
    }
    if (seen == 2) return index;
  }
  return null;
}
