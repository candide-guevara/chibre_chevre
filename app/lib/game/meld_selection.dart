import 'package:chibre_core/chibre_core.dart';

/// The melds formed by exactly the [selection] of cards: a single meld, or
/// several (e.g. a sequence and four of a kind) whose cards together are the
/// selection. Null when the selection is not a valid announcement.
List<Meld>? meldsFromSelection(CardSet selection) {
  final single = Meld.fromCards(selection);
  if (single != null) return [single];
  final melds = findBestMelds(selection);
  final covered = melds.fold(CardSet.empty, (all, meld) => all | meld.cards);
  if (melds.isEmpty || covered != selection) return null;
  return validateMelds(melds, selection) == null ? melds : null;
}
