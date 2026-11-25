import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/game_controller.dart';
import '../strings.dart';
import '../theme/flow_color.dart';
import '../widgets/rematch_buttons.dart';
import 'insights_screen.dart';

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

  static const _happyGoat = 'assets/images/chevre_happy_blue.webp';
  static const _sadGoat = 'assets/images/chevre_sad_blue.webp';

  /// The goat's share of the screen width, as on the start screen.
  static const _goatWidthFactor = 1 / 3;

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
                FractionallySizedBox(
                  widthFactor: _goatWidthFactor,
                  child: Image.asset(won ? _happyGoat : _sadGoat),
                ),
                const SizedBox(height: 16),
                Text(
                  won ? Strings.victory : Strings.defeat,
                  style: text.displaySmall,
                ),
                const SizedBox(height: 24),
                Text(
                  Strings.ourScore(table.scores[team]),
                  style: text.headlineSmall,
                ),
                Text(
                  Strings.theirScore(table.scores[opponentTeam(team)]),
                  style: text.headlineSmall,
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    flowRoute(
                      context,
                      (_) => InsightsScreen(controller: controller),
                    ),
                  ),
                  child: const Text(Strings.gameAnalysis),
                ),
                const SizedBox(height: 16),
                RematchButtons(
                  controller: controller,
                  table: table,
                  sameCardsOption: false,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: onHome,
                  child: const Text(Strings.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
