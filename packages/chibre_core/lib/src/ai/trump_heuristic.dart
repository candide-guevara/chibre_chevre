import '../engine/card.dart';
import '../engine/card_set.dart';
import '../engine/stoeck.dart';
import '../engine/trump_mode.dart';

/// Below this hand strength the heuristic player passes the trump choice.
const chibrerThreshold = 55.0;

// Indexed by Rank.index: 6, 7, 8, 9, 10, J, Q, K, A.
const _trumpCardValues = [4, 4, 4, 14, 6, 20, 6, 7, 10];

/// A rough estimate of how good [hand] is with [mode] as trump.
double handStrength(CardSet hand, TrumpMode mode) {
  final trump = mode.trumpSuit;
  if (trump == null) return _noTrumpStrength(hand, mode == TrumpMode.obenabe);

  final trumps = hand.ofSuit(trump);
  var score = trumps.length * 5.0;
  for (final card in trumps.cards) {
    score += _trumpCardValues[card.rank.index];
  }
  if (holdsStoeck(hand, mode)) score += 8;
  for (final suit in Suit.values.where((s) => s != trump)) {
    final cards = hand.ofSuit(suit);
    if (cards.contains(Card(suit, Rank.ace))) {
      score += 10;
      if (cards.contains(Card(suit, Rank.king))) score += 4;
    }
    if (cards.isEmpty && trumps.length >= 3) score += 3;
  }
  return score;
}

/// Counts the cards that should win tricks from the top of each suit.
double _noTrumpStrength(CardSet hand, bool highWins) {
  final order = highWins ? Rank.values.reversed.toList() : Rank.values;
  var score = 0.0;
  for (final suit in Suit.values) {
    var masters = 0;
    while (
        masters < order.length && hand.contains(Card(suit, order[masters]))) {
      masters++;
    }
    if (masters > 0) score += masters * 12 + hand.ofSuit(suit).length * 2;
  }
  return score;
}

TrumpMode bestHeuristicMode(CardSet hand, List<TrumpMode> allowed) {
  var best = allowed.first;
  for (final mode in allowed.skip(1)) {
    if (handStrength(hand, mode) > handStrength(hand, best)) best = mode;
  }
  return best;
}
