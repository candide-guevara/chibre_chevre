import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../labels.dart';
import '../theme/chibre_theme.dart';

/// Shown after the first trick: every player's meld calls with their cards,
/// and the team whose melds count. Closed by a tap.
class MeldSummary extends StatelessWidget {
  const MeldSummary({
    super.key,
    required this.player,
    required this.nicknames,
    required this.multiplier,
    required this.onDismiss,
  });

  final PlayerView player;
  final List<String> nicknames;
  final int multiplier;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final melds = player.revealedMelds;
    final team = winningMeldTeam(
      melds,
      player.mode!,
      player.completedTricks.first.leader,
    );
    final points = team == null ? 0 : teamMeldPoints(melds, team) * multiplier;
    return GestureDetector(
      onTap: onDismiss,
      child: Card(
        color: ChibreColors.feltDark,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Annonces', style: text.titleLarge),
              const SizedBox(height: 12),
              for (var seat = 0; seat < seatCount; seat++)
                if (melds[seat].isNotEmpty)
                  Text(
                    '${nicknames[seat]} : '
                    '${melds[seat].map(meldName).join(' · ')}',
                    style: text.titleMedium,
                  ),
              if (team != null) ...[
                const SizedBox(height: 12),
                Text(
                  team == teamOf(player.seat)
                      ? 'Nous +$points'
                      : 'Ordi +$points',
                  style: text.titleMedium?.copyWith(color: ChibreColors.brass),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Touchez pour continuer',
                style: text.bodySmall?.copyWith(
                  color: ChibreColors.ivory.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
