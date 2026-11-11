import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme/chibre_theme.dart';

/// Shown between two deals: what each team scored in the round.
class RoundSummary extends StatelessWidget {
  const RoundSummary({
    super.key,
    required this.roundPoints,
    required this.team,
    required this.onDismiss,
  });

  final List<int> roundPoints;
  final int team;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onDismiss,
      child: Card(
        color: UiColors.popup,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Strings.roundOver, style: text.titleLarge),
              const SizedBox(height: 12),
              Text(
                Strings.gain(ours: true, points: roundPoints[team]),
                style: text.titleMedium,
              ),
              Text(
                Strings.gain(
                  ours: false,
                  points: roundPoints[opponentTeam(team)],
                ),
                style: text.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                Strings.tapToContinue,
                style: text.bodySmall?.copyWith(color: UiColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
