import 'meld.dart';
import 'seat.dart';
import 'trump_mode.dart';

/// Positive if [a] beats [b], negative if [b] beats [a], 0 if equal.
///
/// Higher value wins, then more cards, then higher cards (lower cards in
/// undenufe), then a sequence in the trump suit.
int compareMelds(Meld a, Meld b, TrumpMode mode) {
  if (a.value != b.value) return a.value - b.value;
  if (a.cards.length != b.cards.length) return a.cards.length - b.cards.length;
  final height = mode == TrumpMode.undenufe
      ? b.lowRank.index - a.lowRank.index
      : a.highRank.index - b.highRank.index;
  if (height != 0) return height;
  return _trumpBonus(a, mode) - _trumpBonus(b, mode);
}

int _trumpBonus(Meld meld, TrumpMode mode) =>
    meld.suit != null && meld.suit == mode.trumpSuit ? 1 : 0;

/// The team whose melds count, or null if nobody announced any.
/// On a perfect tie the player who announced first (from [firstSeat]) wins.
int? winningMeldTeam(
    List<List<Meld>> meldsBySeat, TrumpMode mode, int firstSeat) {
  Meld? best;
  int? bestSeat;
  for (var i = 0; i < seatCount; i++) {
    final seat = (firstSeat + i) % seatCount;
    for (final meld in meldsBySeat[seat]) {
      if (best == null || compareMelds(meld, best, mode) > 0) {
        best = meld;
        bestSeat = seat;
      }
    }
  }
  return bestSeat == null ? null : teamOf(bestSeat);
}

/// Total meld points of [team], before multiplier.
int teamMeldPoints(List<List<Meld>> meldsBySeat, int team) {
  var total = 0;
  for (var seat = 0; seat < seatCount; seat++) {
    if (teamOf(seat) != team) continue;
    for (final meld in meldsBySeat[seat]) {
      total += meld.value;
    }
  }
  return total;
}
