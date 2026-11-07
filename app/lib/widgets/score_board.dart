import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import '../theme/chibre_theme.dart';
import 'trump_indicator.dart';

/// Both teams' scores, the target and the current trump.
class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.scores,
    required this.team,
    required this.target,
    this.mode,
    this.multiplier = 1,
  });

  final List<int> scores;

  /// The viewer's team ("Nous").
  final int team;
  final int target;
  final TrumpMode? mode;
  final int multiplier;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      color: ChibreColors.feltDark,
      // Fixed, so that the table below does not move when the trump appears.
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text('Nous ${scores[team]}', style: text.titleMedium),
          const SizedBox(width: 16),
          Text('Ordi ${scores[opponentTeam(team)]}', style: text.titleMedium),
          const SizedBox(width: 8),
          Text('/ $target', style: text.bodySmall),
          const Spacer(),
          if (mode != null) TrumpIndicator(mode: mode!, multiplier: multiplier),
        ],
      ),
    );
  }
}
