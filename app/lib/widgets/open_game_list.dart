import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

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
      return const Center(child: Text('Recherche de parties sur le réseau…'));
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
                ? 'En pause — ${listing.scores[0]} : ${listing.scores[1]}'
                : 'Hôte : ${listing.hostNickname}',
          ),
          trailing: listing.isPaused
              ? Chip(
                  label: Text(joinable ? 'Reprendre' : 'En pause'),
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
