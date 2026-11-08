import 'package:chibre_core/chibre_core.dart' as core;
import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../game/hand_order.dart';
import '../labels.dart';
import '../theme/chibre_theme.dart';
import 'playing_card.dart';

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
      color: ChibreColors.feltDark,
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
                  style: text.titleMedium?.copyWith(color: ChibreColors.brass),
                ),
              ],
            ),
            Text(where, style: text.bodySmall),
            const SizedBox(height: 8),
            _cards(
              'Main',
              sortHand(blunder.hand, blunder.mode, byTrump: sortByTrump),
            ),
            if (blunder.trick.isNotEmpty) _cards('Sur la table', blunder.trick),
            const SizedBox(height: 8),
            Text(_explanation(), style: text.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _cards(String label, List<core.Card> cards) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        SizedBox(width: 90, child: Text(label)),
        Expanded(
          child: Wrap(
            spacing: 2,
            runSpacing: 2,
            children: [
              for (final card in cards) PlayingCard(card: card, width: 26),
            ],
          ),
        ),
      ],
    ),
  );

  String _explanation() => switch (blunder.kind) {
    BlunderKind.trumpChoice =>
      'Choisi : ${trumpOptionName(blunder.chosenTrump!)}. '
          'Mieux : ${trumpOptionName(blunder.bestTrump!)}.',
    BlunderKind.cardPlay =>
      'Joué : ${cardName(blunder.playedCard!)}. '
          'Mieux : ${cardName(blunder.bestCard!)}.',
    BlunderKind.missedMeld =>
      'Non annoncé : ${blunder.missedMelds.map(meldName).join(', ')}.',
    BlunderKind.missedStoeck =>
      'Le Stöck n\'a pas été annoncé avec ${cardName(blunder.playedCard!)}.',
  };
}
