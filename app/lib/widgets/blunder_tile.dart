import 'package:chibre_core/chibre_core.dart' as core;
import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../game/hand_order.dart';
import '../strings.dart';
import '../theme/chibre_theme.dart';
import 'card_label.dart';

/// One blunder of the insights: the situation, what was done, what was
/// better and what it cost.
class BlunderTile extends StatelessWidget {
  const BlunderTile({
    super.key,
    required this.blunder,
    required this.sortByTrump,
  });

  final Blunder blunder;
  final bool sortByTrump;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final where = blunder.trickIndex == null
        ? Strings.round(blunder.roundIndex)
        : Strings.roundAndTrick(blunder.roundIndex, blunder.trickIndex!);
    return Card(
      color: UiColors.panel,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    Strings.blunderTitle(blunder.kind),
                    style: text.titleMedium,
                  ),
                ),
                Text(
                  Strings.pointsLost(blunder.pointsLost),
                  style: text.titleMedium?.copyWith(color: UiColors.accent),
                ),
              ],
            ),
            Text(where, style: text.bodySmall),
            const SizedBox(height: 8),
            if (blunder.mode case final mode?)
              _row(Strings.trump, Text(Strings.trumpWithSymbol(mode))),
            _cards(
              Strings.hand,
              sortHand(blunder.hand, blunder.mode, byTrump: sortByTrump),
            ),
            if (blunder.trick.isNotEmpty)
              _cards(Strings.onTheTable, blunder.trick),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(children: _explanation()),
              style: text.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, Widget content) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        SizedBox(width: 90, child: Text(label)),
        Expanded(child: content),
      ],
    ),
  );

  Widget _cards(String label, List<core.Card> cards) => _row(
    label,
    Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [for (final card in cards) CardLabel(card)],
    ),
  );

  List<InlineSpan> _explanation() => switch (blunder.kind) {
    BlunderKind.trumpChoice => [
      TextSpan(
        text: Strings.chosenAndBetter(blunder.chosenTrump!, blunder.bestTrump!),
      ),
    ],
    BlunderKind.cardPlay => [
      const TextSpan(text: Strings.played),
      cardSpan(blunder.playedCard!),
      const TextSpan(text: Strings.better),
      cardSpan(blunder.bestCard!),
      const TextSpan(text: Strings.sentenceEnd),
    ],
    BlunderKind.missedMeld => [
      const TextSpan(text: Strings.notAnnounced),
      for (final (i, meld) in blunder.missedMelds.indexed) ...[
        TextSpan(text: '${i == 0 ? '' : Strings.listSeparator}${meld.value} '),
        for (final card in meld.cards.cards) ...[
          cardSpan(card),
          const TextSpan(text: ' '),
        ],
      ],
    ],
    BlunderKind.missedStoeck => [
      const TextSpan(text: Strings.stoeckNotAnnounced),
      cardSpan(blunder.playedCard!),
      const TextSpan(text: Strings.sentenceEnd),
    ],
  };
}
