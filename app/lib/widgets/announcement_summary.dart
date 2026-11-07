import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../labels.dart';
import '../theme/chibre_theme.dart';

/// Shown after a trick with announcements: the meld calls with their cards
/// after the first trick, and who announced Stöck after the trick in which
/// it was. Closed by a tap.
class AnnouncementSummary extends StatelessWidget {
  const AnnouncementSummary({
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
    final tricks = player.completedTricks;
    final melds = player.revealedMelds;
    final showsMelds =
        tricks.length == 1 && melds.any((seatMelds) => seatMelds.isNotEmpty);
    final stoeckSeat =
        stoeckTrickIndex(tricks, player.stoeckSeat, player.mode!) ==
            tricks.length - 1
        ? player.stoeckSeat
        : null;
    final meldTeam = showsMelds
        ? winningMeldTeam(melds, player.mode!, tricks.first.leader)
        : null;

    String gain(int team, int points) =>
        '${team == teamOf(player.seat) ? 'Nous' : 'Ordi'} +${points * multiplier}';
    final gainStyle = text.titleMedium?.copyWith(color: ChibreColors.brass);

    return GestureDetector(
      onTap: onDismiss,
      child: Card(
        color: ChibreColors.feltDark,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(showsMelds ? 'Annonces' : 'Stöck', style: text.titleLarge),
              const SizedBox(height: 12),
              if (showsMelds)
                for (var seat = 0; seat < seatCount; seat++)
                  if (melds[seat].isNotEmpty)
                    Text(
                      '${nicknames[seat]} : '
                      '${melds[seat].map(meldName).join(' · ')}',
                      style: text.titleMedium,
                    ),
              if (stoeckSeat != null)
                Text(
                  '${nicknames[stoeckSeat]} : Stöck',
                  style: text.titleMedium,
                ),
              const SizedBox(height: 12),
              if (meldTeam != null)
                Text(
                  gain(meldTeam, teamMeldPoints(melds, meldTeam)),
                  style: gainStyle,
                ),
              if (stoeckSeat != null)
                Text(gain(teamOf(stoeckSeat), stoeckPoints), style: gainStyle),
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
