import '../engine/card.dart';
import '../engine/card_set.dart';
import '../engine/card_values.dart';
import '../engine/legal_moves.dart';
import '../engine/trick.dart';
import '../engine/trump_mode.dart';

/// Picks a card with simple rules of thumb. Used by the heuristic player and
/// to finish the deals sampled by the expert player's search.
///
/// [unplayed] are the cards not played yet, the player's hand included; it
/// is public knowledge so the policy doesn't cheat.
Card heuristicCard(
    CardSet hand, List<Card> trick, TrumpMode mode, CardSet unplayed) {
  final legal = legalMoves(hand, trick, mode).cards;
  if (legal.length == 1) return legal.single;
  final others = unplayed - hand;
  if (trick.isEmpty) return _lead(hand, legal, mode, others);

  final winnerIndex = winningIndex(trick, mode);
  final winningCard = trick[winnerIndex];
  final partnerWinning = trick.length - winnerIndex == 2;
  final isLast = trick.length == 3;
  if (partnerWinning) {
    final safe = isLast || _isSafe(winningCard, mode, others);
    return safe ? _richest(legal, mode) : _cheapest(legal, mode);
  }

  final led = trick.first.suit;
  final strengthToBeat = trickStrength(winningCard, led, mode);
  final winners = legal
      .where((card) => trickStrength(card, led, mode) > strengthToBeat)
      .toList();
  if (winners.isEmpty) return _cheapest(legal, mode);
  if (isLast) return _cheapest(winners, mode);
  final safeWinners =
      winners.where((card) => _isSafe(card, mode, others)).toList();
  return _cheapest(safeWinners.isEmpty ? winners : safeWinners, mode);
}

Card _lead(CardSet hand, List<Card> legal, TrumpMode mode, CardSet others) {
  final trump = mode.trumpSuit;
  if (trump != null) {
    final trumps = hand.ofSuit(trump);
    final opponentTrumps = others.ofSuit(trump);
    if (opponentTrumps.isNotEmpty && trumps.length >= 3) {
      final master = trumps.cards.where((c) => _isMaster(c, mode, others));
      if (master.isNotEmpty) return master.first;
    }
  }
  final masters = legal
      .where((card) => card.suit != trump && _isMaster(card, mode, others))
      .toList();
  if (masters.isNotEmpty) return _richest(masters, mode);
  final plain = legal.where((card) => card.suit != trump).toList();
  return _cheapest(plain.isEmpty ? legal : plain, mode);
}

/// No unplayed card of the same suit beats [card].
bool _isMaster(Card card, TrumpMode mode, CardSet others) =>
    strongerInSuit(card, others, mode).isEmpty;

/// [card] can't be beaten: it is master and can't be trumped.
bool _isSafe(Card card, TrumpMode mode, CardSet others) {
  if (!_isMaster(card, mode, others)) return false;
  final trump = mode.trumpSuit;
  return trump == null || card.suit == trump || others.ofSuit(trump).isEmpty;
}

/// The card that gives away the fewest points, keeping trumps if possible.
Card _cheapest(List<Card> cards, TrumpMode mode) =>
    _minBy(cards, (card) => _cost(card, mode));

/// The card with the most points, to give to a partner who wins the trick.
Card _richest(List<Card> cards, TrumpMode mode) {
  final plain = cards.where((card) => card.suit != mode.trumpSuit).toList();
  if (plain.isEmpty) return _cheapest(cards, mode);
  return _minBy(plain,
      (card) => -cardPoints(card, mode) * 100 + suitStrength(card, mode));
}

int _cost(Card card, TrumpMode mode) =>
    cardPoints(card, mode) * 100 +
    (card.suit == mode.trumpSuit ? 50 : 0) +
    suitStrength(card, mode);

Card _minBy(List<Card> cards, int Function(Card) key) {
  var best = cards.first;
  var bestKey = key(best);
  for (final card in cards.skip(1)) {
    final value = key(card);
    if (value < bestKey) {
      best = card;
      bestKey = value;
    }
  }
  return best;
}
