import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/game_controller.dart';
import '../strings.dart';
import '../theme/chibre_theme.dart';
import '../theme/screen_theme.dart';
import '../widgets/blunder_tile.dart';
import '../widgets/rematch_buttons.dart';

/// The 3 biggest blunders of each human, found by the expert after the game.
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) => StreamBuilder<TableView>(
    stream: controller.tables,
    initialData: controller.table,
    builder: (context, snapshot) {
      final table = snapshot.data!;
      if (table.phase != TablePhase.gameOver) {
        // A rematch started: back to the table.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) Navigator.of(context).pop();
        });
      }
      return ScreenTheme(
        color: ScreenColors.insights,
        child: Scaffold(
          appBar: AppBar(title: const Text(Strings.gameAnalysis)),
          body: table.insights == null
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(Strings.analysing),
                    ],
                  ),
                )
              : _content(context, table),
        ),
      );
    },
  );

  Widget _content(BuildContext context, TableView table) {
    final text = Theme.of(context).textTheme;
    final humans = [table.seat, if (!table.solo) partnerOf(table.seat)];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final seat in humans) ...[
          Text(table.nicknames[seat], style: text.headlineSmall),
          const SizedBox(height: 8),
          ..._blundersOf(table, seat),
          const SizedBox(height: 24),
        ],
        RematchButtons(
          controller: controller,
          table: table,
          sameCardsOption: true,
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton(
            onPressed: () async {
              await controller.leave();
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: const Text(Strings.home),
          ),
        ),
      ],
    );
  }

  List<Widget> _blundersOf(TableView table, int seat) {
    final blunders = table.insights!.where((b) => b.seat == seat).toList();
    if (blunders.isEmpty) return [const Text(Strings.noBlunder)];
    return [
      for (final blunder in blunders)
        BlunderTile(blunder: blunder, sortByTrump: table.sortByTrump),
    ];
  }
}
