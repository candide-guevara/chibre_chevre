import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/game_controller.dart';
import 'insights_screen.dart';
import '../widgets/rematch_buttons.dart';

/// Final scores, with the way to the insights, a rematch or the start screen.
class EndScreen extends StatelessWidget {
  const EndScreen({
    super.key,
    required this.controller,
    required this.table,
    required this.onHome,
  });

  final GameController controller;
  final TableView table;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final team = teamOf(table.seat);
    final won = table.winningTeam == team;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(won ? 'Victoire !' : 'Défaite', style: text.displaySmall),
                const SizedBox(height: 24),
                Text('Nous ${table.scores[team]}', style: text.headlineSmall),
                Text(
                  'Eux ${table.scores[opponentTeam(team)]}',
                  style: text.headlineSmall,
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => InsightsScreen(controller: controller),
                    ),
                  ),
                  child: const Text('Analyse de la partie'),
                ),
                const SizedBox(height: 16),
                RematchButtons(
                  controller: controller,
                  table: table,
                  sameCardsOption: false,
                ),
                const SizedBox(height: 16),
                OutlinedButton(onPressed: onHome, child: const Text('Accueil')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
