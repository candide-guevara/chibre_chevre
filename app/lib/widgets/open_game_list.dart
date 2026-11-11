import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme/chibre_theme.dart';

/// The games found on the network. Paused games stand out and can only be
/// joined by the player who left them.
class OpenGameList extends StatelessWidget {
  const OpenGameList({
    super.key,
    required this.games,
    required this.installationId,
    required this.onJoin,
  });

  final List<OpenGame> games;
  final String installationId;
  final void Function(OpenGame game) onJoin;

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      return const Center(child: Text(Strings.searchingGames));
    }
    return ListView.separated(
      itemCount: games.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final game = games[index];
        final listing = game.listing;
        final joinable = listing.joinableBy(installationId);
        return ListTile(
          enabled: joinable,
          tileColor: listing.isPaused ? UiColors.panel : null,
          title: Text(listing.name),
          subtitle: Text(
            listing.isPaused
                ? Strings.pausedScores(listing.scores)
                : Strings.hostIs(listing.hostNickname),
          ),
          trailing: listing.isPaused
              ? Chip(
                  label: Text(joinable ? Strings.resumeGame : Strings.paused),
                  backgroundColor: UiColors.accent,
                  labelStyle: const TextStyle(color: UiColors.onAccent),
                )
              : const Icon(Icons.chevron_right),
          onTap: joinable ? () => onJoin(game) : null,
        );
      },
    );
  }
}
