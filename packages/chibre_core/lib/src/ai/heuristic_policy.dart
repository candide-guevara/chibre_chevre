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
///
/// It runs millions of times per decision of the expert player, hence the
/// card sets rather than lists. Ties go to the card with the lowest index.
Card heuristicCard(
    CardSet hand, List<Card> trick, TrumpMode mode, CardSet unplayed) {
  final legal = legalMoves(hand, trick, mode);
  if (legal.withoutFirst.isEmpty) return legal.first;
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

  // The winning card follows the led suit or is a trump.
  final trump = mode.trumpSuit;
  var winners = strongerInSuit(winningCard, legal, mode);
  if (trump != null && winningCard.suit != trump) {
    winners = winners | legal.ofSuit(trump);
  }
  if (winners.isEmpty) return _cheapest(legal, mode);
  if (isLast) return _cheapest(winners, mode);
  var safeWinners = CardSet.empty;
  for (var rest = winners; rest.isNotEmpty; rest = rest.withoutFirst) {
    if (_isSafe(rest.first, mode, others)) {
      safeWinners = safeWinners.add(rest.first);
    }
  }
  return _cheapest(safeWinners.isEmpty ? winners : safeWinners, mode);
}

Card _lead(CardSet hand, CardSet legal, TrumpMode mode, CardSet others) {
  final trump = mode.trumpSuit;
  final plain = trump == null ? legal : legal - CardSet.suit(trump);
  if (trump != null) {
    final trumps = hand.ofSuit(trump);
    if (others.ofSuit(trump).isNotEmpty && trumps.length >= 3) {
      for (var rest = trumps; rest.isNotEmpty; rest = rest.withoutFirst) {
        if (_isMaster(rest.first, mode, others)) return rest.first;
      }
    }
  }
  var masters = CardSet.empty;
  for (var rest = plain; rest.isNotEmpty; rest = rest.withoutFirst) {
    if (_isMaster(rest.first, mode, others)) masters = masters.add(rest.first);
  }
  if (masters.isNotEmpty) return _richest(masters, mode);
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
Card _cheapest(CardSet cards, TrumpMode mode) {
  var best = cards.first;
  var bestCost = _cost(best, mode);
  for (var rest = cards.withoutFirst;
      rest.isNotEmpty;
      rest = rest.withoutFirst) {
    final cost = _cost(rest.first, mode);
    if (cost < bestCost) {
      best = rest.first;
      bestCost = cost;
    }
  }
  return best;
}

/// The card with the most points, to give to a partner who wins the trick.
Card _richest(CardSet cards, TrumpMode mode) {
  final trump = mode.trumpSuit;
  final plain = trump == null ? cards : cards - CardSet.suit(trump);
  if (plain.isEmpty) return _cheapest(cards, mode);
  var best = plain.first;
  var bestKey = _poverty(best, mode);
  for (var rest = plain.withoutFirst;
      rest.isNotEmpty;
      rest = rest.withoutFirst) {
    final key = _poverty(rest.first, mode);
    if (key < bestKey) {
      best = rest.first;
      bestKey = key;
    }
  }
  return best;
}

int _cost(Card card, TrumpMode mode) =>
    cardPoints(card, mode) * 100 +
    (card.suit == mode.trumpSuit ? 50 : 0) +
    suitStrength(card, mode);

int _poverty(Card card, TrumpMode mode) =>
    -cardPoints(card, mode) * 100 + suitStrength(card, mode);
