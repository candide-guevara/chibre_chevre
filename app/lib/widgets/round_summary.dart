import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../theme/chibre_theme.dart';

/// Shown between two deals: what each team scored in the round.
class RoundSummary extends StatelessWidget {
  const RoundSummary({
    super.key,
    required this.roundPoints,
    required this.team,
  });

  final List<int> roundPoints;
  final int team;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      color: ChibreColors.feltDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Manche terminée', style: text.titleLarge),
            const SizedBox(height: 12),
            Text('Nous +${roundPoints[team]}', style: text.titleMedium),
            Text(
              'Eux +${roundPoints[opponentTeam(team)]}',
              style: text.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
