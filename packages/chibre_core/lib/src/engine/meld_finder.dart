import 'card.dart';
import 'card_set.dart';
import 'meld.dart';

/// All the melds of [hand]: every maximal sequence and every four of a kind.
/// Together they are the best possible announcement.
List<Meld> findBestMelds(CardSet hand) {
  final melds = <Meld>[];
  for (final suit in Suit.values) {
    var run = <Card>[];
    for (final rank in Rank.values) {
      final card = Card(suit, rank);
      if (hand.contains(card)) {
        run.add(card);
        continue;
      }
      _addSequence(run, melds);
      run = [];
    }
    _addSequence(run, melds);
  }
  for (final rank in fourOfAKindValues.keys) {
    final four = CardSet.of(Suit.values.map((suit) => Card(suit, rank)));
    if (hand.containsAll(four)) melds.add(Meld.fromCards(four)!);
  }
  return melds;
}

void _addSequence(List<Card> run, List<Meld> melds) {
  if (run.length >= 3) melds.add(Meld.fromCards(CardSet.of(run))!);
}
