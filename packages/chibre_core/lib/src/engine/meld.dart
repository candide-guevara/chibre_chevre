import 'card.dart';
import 'card_set.dart';

enum MeldKind { sequence, fourOfAKind }

const _sequenceValues = {3: 20, 4: 50, 5: 100, 6: 150, 7: 200, 8: 250, 9: 300};

const fourOfAKindValues = {
  Rank.jack: 200,
  Rank.nine: 150,
  Rank.ace: 100,
  Rank.king: 100,
  Rank.queen: 100,
  Rank.ten: 100,
};

/// A meld (annonce): a sequence of 3+ cards of the same suit, or four cards
/// of the same rank (sixes, sevens and eights don't count).
final class Meld {
  Meld._(this.kind, this.cards, this.value);

  /// The meld formed by exactly [cards], or null if they don't form one.
  static Meld? fromCards(CardSet cards) {
    final list = cards.cards;
    if (list.length == 4 && list.every((c) => c.rank == list.first.rank)) {
      final value = fourOfAKindValues[list.first.rank];
      return value == null ? null : Meld._(MeldKind.fourOfAKind, cards, value);
    }
    final value = _sequenceValues[list.length];
    if (value == null) return null;
    for (var i = 1; i < list.length; i++) {
      if (list[i].suit != list.first.suit ||
          list[i].rank.index != list[i - 1].rank.index + 1) {
        return null;
      }
    }
    return Meld._(MeldKind.sequence, cards, value);
  }

  final MeldKind kind;
  final CardSet cards;
  final int value;

  Rank get highRank => cards.cards.last.rank;

  Rank get lowRank => cards.cards.first.rank;

  /// The suit of a sequence, null for four of a kind.
  Suit? get suit => kind == MeldKind.sequence ? cards.cards.first.suit : null;

  @override
  bool operator ==(Object other) => other is Meld && other.cards == cards;

  @override
  int get hashCode => cards.bits.hashCode;

  @override
  String toString() => 'Meld($value: ${cards.cards.join(' ')})';
}
