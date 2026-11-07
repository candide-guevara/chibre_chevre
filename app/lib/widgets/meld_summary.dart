import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../labels.dart';
import '../theme/chibre_theme.dart';

/// Shown after the first trick: every player's meld calls and the team whose
/// melds count. Only the cards a player could see at a real table are shown:
/// their own melds and the winning team's.
class MeldSummary extends StatelessWidget {
  const MeldSummary({
    super.key,
    required this.player,
    required this.nicknames,
    required this.multiplier,
  });

  final PlayerView player;
  final List<String> nicknames;
  final int multiplier;

  /// The team whose melds count, null when nobody announced any.
  int? get _scoringTeam {
    final viewerTeam = teamOf(player.seat);
    final opponents = opponentTeam(viewerTeam);
    final opponentsShown = [
      for (var seat = 0; seat < seatCount; seat++)
        if (teamOf(seat) == opponents) ...player.revealedMelds[seat],
    ].isNotEmpty;
    if (opponentsShown) return opponents;
    final anyCalled = player.announcedMeldValues.any((v) => v.isNotEmpty);
    return anyCalled ? viewerTeam : null;
  }

  String _calls(int seat) {
    final shown = player.revealedMelds[seat];
    if (shown.isNotEmpty) return shown.map(meldName).join(' · ');
    return player.announcedMeldValues[seat].join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final team = _scoringTeam;
    final points = team == null
        ? 0
        : [
                for (var seat = 0; seat < seatCount; seat++)
                  if (teamOf(seat) == team)
                    for (final meld in player.revealedMelds[seat]) meld.value,
              ].fold(0, (sum, value) => sum + value) *
              multiplier;
    return Card(
      color: ChibreColors.feltDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Annonces', style: text.titleLarge),
            const SizedBox(height: 12),
            for (var seat = 0; seat < seatCount; seat++)
              if (player.announcedMeldValues[seat].isNotEmpty)
                Text(
                  '${nicknames[seat]} : ${_calls(seat)}',
                  style: text.titleMedium,
                ),
            if (team != null) ...[
              const SizedBox(height: 12),
              Text(
                team == teamOf(player.seat) ? 'Nous +$points' : 'Ordi +$points',
                style: text.titleMedium?.copyWith(color: ChibreColors.brass),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
