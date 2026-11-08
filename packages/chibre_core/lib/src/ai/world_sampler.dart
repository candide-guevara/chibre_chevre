import 'dart:math';

import '../engine/card.dart';
import '../engine/card_set.dart';
import '../engine/card_values.dart';
import '../engine/player_view.dart';
import '../engine/seat.dart';

/// Deals the cards a player can't see to the other seats, consistently with
/// what the player observed: suits others showed they don't have and meld
/// cards they revealed.
class WorldSampler {
  WorldSampler(this.view) {
    _hands[view.seat] = view.hand;
    _capacity[view.seat] = 0;
    var unknown = CardSet.full - view.hand - view.playedCards;
    for (var seat = 0; seat < seatCount; seat++) {
      if (seat == view.seat) continue;
      var known = CardSet.empty;
      for (final meld in view.revealedMelds[seat]) {
        known = known | meld.cards;
      }
      known = (known & unknown);
      _hands[seat] = known;
      unknown = unknown - known;
      _capacity[seat] = view.handSizeOf(seat) - known.length;
    }
    _unknown = unknown.cards;
    if (view.mode != null) _inferVoids();
  }

  final PlayerView view;
  final _hands = List.filled(seatCount, CardSet.empty);
  final _capacity = List.filled(seatCount, 0);
  final _forbidden = List.filled(seatCount, CardSet.empty);
  late final List<Card> _unknown;

  /// The cards known to be in each seat's hand.
  List<CardSet> get hands => List.unmodifiable(_hands);

  /// The four hands of a random deal compatible with the observations.
  List<CardSet> sample(Random random) {
    for (var attempt = 0; attempt < 20; attempt++) {
      final hands = _tryDeal(random, respectVoids: true);
      if (hands != null) return hands;
    }
    return _tryDeal(random, respectVoids: false)!;
  }

  void _inferVoids() {
    final mode = view.mode!;
    final trump = mode.trumpSuit;
    for (final trick in view.allTricks) {
      if (trick.cards.isEmpty) continue;
      final led = trick.cards.first.suit;
      var bestTrump = -1;
      for (var position = 0; position < trick.cards.length; position++) {
        final card = trick.cards[position];
        final seat = trick.seatAt(position);
        if (card.suit != led) {
          if (led == trump) {
            // Didn't follow trump: at most the jack of trump is left.
            _forbid(seat, CardSet.suit(trump!).remove(Card(trump, Rank.jack)));
          } else if (card.suit != trump) {
            _forbid(seat, CardSet.suit(led));
          } else if (suitStrength(card, mode) < bestTrump) {
            // Undertrumping is only allowed with nothing but trumps.
            _forbid(seat, CardSet.full - CardSet.suit(trump!));
          }
        }
        if (card.suit == trump) {
          bestTrump = max(bestTrump, suitStrength(card, mode));
        }
      }
    }
  }

  void _forbid(int seat, CardSet cards) {
    if (seat != view.seat) _forbidden[seat] = _forbidden[seat] | cards;
  }

  List<CardSet>? _tryDeal(Random random, {required bool respectVoids}) {
    final hands = List.of(_hands);
    final capacity = List.of(_capacity);
    var cards = List.of(_unknown)..shuffle(random);
    if (respectVoids && _mustSort) cards = _byEligibleCount(cards);
    final eligible = <int>[];
    for (final card in cards) {
      eligible.clear();
      var weight = 0;
      for (var seat = 0; seat < seatCount; seat++) {
        if (capacity[seat] == 0) continue;
        if (respectVoids && _forbidden[seat].contains(card)) continue;
        eligible.add(seat);
        weight += capacity[seat];
      }
      if (eligible.isEmpty) return null;
      var pick = random.nextInt(weight);
      var seat = eligible.first;
      for (final candidate in eligible) {
        seat = candidate;
        pick -= capacity[candidate];
        if (pick < 0) break;
      }
      hands[seat] = hands[seat].add(card);
      capacity[seat]--;
    }
    return hands;
  }

  /// For each card index, the number of seats it may be dealt to.
  late final _eligible = [for (final card in Card.all) _eligibleCount(card)];

  /// Whether some unknown cards may go to fewer seats than others.
  late final _mustSort =
      _unknown.map((card) => _eligible[card.index]).toSet().length > 1;

  /// [cards] with those that may go to the fewest seats first, in a stable
  /// order like [List.sort] on so few cards.
  List<Card> _byEligibleCount(List<Card> cards) => [
        for (var count = 0; count <= seatCount; count++)
          for (final card in cards)
            if (_eligible[card.index] == count) card,
      ];

  int _eligibleCount(Card card) {
    var count = 0;
    for (var seat = 0; seat < seatCount; seat++) {
      if (_capacity[seat] > 0 && !_forbidden[seat].contains(card)) count++;
    }
    return count;
  }
}
