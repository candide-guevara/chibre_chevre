import 'package:chibre_core/chibre_core.dart' as core;
import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../game/hand_order.dart';
import '../labels.dart';
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
        ? 'Manche ${blunder.roundIndex + 1}'
        : 'Manche ${blunder.roundIndex + 1}, pli ${blunder.trickIndex! + 1}';
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
                    blunderTitle(blunder.kind),
                    style: text.titleMedium,
                  ),
                ),
                Text(
                  '−${blunder.pointsLost.round()} pts',
                  style: text.titleMedium?.copyWith(color: UiColors.accent),
                ),
              ],
            ),
            Text(where, style: text.bodySmall),
            const SizedBox(height: 8),
            if (blunder.mode case final mode?)
              _row('Atout', Text('${modeSymbol(mode)} ${_trumpName(mode)}')),
            _cards(
              'Main',
              sortHand(blunder.hand, blunder.mode, byTrump: sortByTrump),
            ),
            if (blunder.trick.isNotEmpty) _cards('Sur la table', blunder.trick),
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

  static String _trumpName(TrumpMode mode) =>
      mode.trumpSuit == null ? modeName(mode) : suitName(mode.trumpSuit!);

  List<InlineSpan> _explanation() => switch (blunder.kind) {
    BlunderKind.trumpChoice => [
      TextSpan(
        text:
            'Choisi : ${trumpOptionName(blunder.chosenTrump!)}. '
            'Mieux : ${trumpOptionName(blunder.bestTrump!)}.',
      ),
    ],
    BlunderKind.cardPlay => [
      const TextSpan(text: 'Joué : '),
      cardSpan(blunder.playedCard!),
      const TextSpan(text: '. Mieux : '),
      cardSpan(blunder.bestCard!),
      const TextSpan(text: '.'),
    ],
    BlunderKind.missedMeld => [
      const TextSpan(text: 'Non annoncé : '),
      for (final (i, meld) in blunder.missedMelds.indexed) ...[
        TextSpan(text: '${i == 0 ? '' : ', '}${meld.value} '),
        for (final card in meld.cards.cards) ...[
          cardSpan(card),
          const TextSpan(text: ' '),
        ],
      ],
    ],
    BlunderKind.missedStoeck => [
      const TextSpan(text: 'Le Stöck n\'a pas été annoncé avec '),
      cardSpan(blunder.playedCard!),
      const TextSpan(text: '.'),
    ],
  };
}
