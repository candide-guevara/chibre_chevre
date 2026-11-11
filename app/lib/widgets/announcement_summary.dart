import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../strings.dart';
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

    String gain(int team, int points) => Strings.gain(
      ours: team == teamOf(player.seat),
      points: points * multiplier,
    );
    final gainStyle = text.titleMedium?.copyWith(color: UiColors.accent);

    return GestureDetector(
      onTap: onDismiss,
      child: Card(
        color: UiColors.popup,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                showsMelds ? Strings.announcements : Strings.stoeck,
                style: text.titleLarge,
              ),
              const SizedBox(height: 12),
              if (showsMelds)
                for (var seat = 0; seat < seatCount; seat++)
                  if (melds[seat].isNotEmpty)
                    Text(
                      Strings.playerLine(
                        nicknames[seat],
                        melds[seat]
                            .map(Strings.meldName)
                            .join(Strings.callSeparator),
                      ),
                      style: text.titleMedium,
                    ),
              if (stoeckSeat != null)
                Text(
                  Strings.playerLine(nicknames[stoeckSeat], Strings.stoeck),
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
