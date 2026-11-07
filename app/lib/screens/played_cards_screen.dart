import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/game_controller.dart';
import '../labels.dart';
import '../widgets/trick_row.dart';

/// What happened so far in the round, as this player could see it: the
/// melds and Stöck announced, and the cards of every trick.
class PlayedCardsScreen extends StatelessWidget {
  const PlayedCardsScreen({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cartes jouées')),
    body: StreamBuilder<TableView>(
      stream: controller.tables,
      initialData: controller.table,
      builder: (context, snapshot) {
        final table = snapshot.data;
        final player = table?.player;
        if (table == null || player == null) return const SizedBox.shrink();
        final text = Theme.of(context).textTheme;
        final announcements = _announcements(table, player);
        final tricks = player.allTricks.where(
          (trick) => trick.cards.isNotEmpty,
        );
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Annonces', style: text.titleMedium),
            const SizedBox(height: 8),
            if (announcements.isEmpty)
              const Text('Aucune annonce')
            else
              for (final line in announcements) Text(line),
            const SizedBox(height: 24),
            Text('Plis', style: text.titleMedium),
            if (tricks.isEmpty) const Text('Aucune carte jouée'),
            for (final (index, trick) in tricks.indexed)
              TrickRow(
                number: index + 1,
                trick: trick,
                nicknames: table.nicknames,
                style: table.cardStyle,
                winner: trick.isComplete ? trick.winner(player.mode!) : null,
              ),
          ],
        );
      },
    ),
  );

  /// One line per player who announced something: the melds' cards once
  /// shown, only their values before.
  List<String> _announcements(TableView table, PlayerView player) => [
    for (var seat = 0; seat < seatCount; seat++)
      if (player.announcedMeldValues[seat].isNotEmpty ||
          player.stoeckSeat == seat)
        '${table.nicknames[seat]} : ${[if (player.revealedMelds[seat].isNotEmpty) ...player.revealedMelds[seat].map(meldName) else ...player.announcedMeldValues[seat].map((value) => '$value'), if (player.stoeckSeat == seat) 'Stöck'].join(' · ')}',
  ];
}
