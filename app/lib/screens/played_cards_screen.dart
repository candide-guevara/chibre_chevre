import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/game_controller.dart';
import '../labels.dart';
import '../widgets/suit_column.dart';

/// What happened so far in the round, as this player could see it: the
/// melds and Stöck announced, then the cards played, one column per suit.
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
        final played = player.playedCards;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Annonces', style: text.titleMedium),
            const SizedBox(height: 8),
            if (announcements.isEmpty)
              const Text('Aucune annonce')
            else
              for (final line in announcements) Text(line),
            const Divider(height: 32),
            Text('Cartes jouées', style: text.titleMedium),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final suit in _suitOrder)
                  Expanded(
                    child: SuitColumn(
                      suit: suit,
                      cards: played.ofSuit(suit).cards,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    ),
  );

  /// One line per player who announced something.
  List<String> _announcements(TableView table, PlayerView player) => [
    for (var seat = 0; seat < seatCount; seat++)
      if (_calls(player, seat) case final calls when calls.isNotEmpty)
        '${table.nicknames[seat]} : ${calls.join(' · ')}',
  ];

  /// What [seat] announced: the melds' cards once shown, only their values
  /// before, and Stöck.
  List<String> _calls(PlayerView player, int seat) => [
    if (player.revealedMelds[seat].isNotEmpty)
      ...player.revealedMelds[seat].map(meldName)
    else
      ...player.announcedMeldValues[seat].map((value) => '$value'),
    if (player.stoeckSeat == seat) 'Stöck',
  ];

  /// The same order as the hand.
  static const _suitOrder = [
    Suit.hearts,
    Suit.spades,
    Suit.diamonds,
    Suit.clubs,
  ];
}
