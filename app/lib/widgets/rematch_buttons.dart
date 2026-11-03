import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/game_controller.dart';

/// Proposes a rematch, or answers the other player's proposal.
class RematchButtons extends StatelessWidget {
  const RematchButtons({
    super.key,
    required this.controller,
    required this.table,
    required this.sameCardsOption,
  });

  final GameController controller;
  final TableView table;

  /// Also offer a rematch with the same deals.
  final bool sameCardsOption;

  @override
  Widget build(BuildContext context) {
    final offer = table.rematch;
    if (offer != null && offer.proposedBy == table.seat) {
      return Text(
        'En attente de la réponse de ${table.nicknames[partnerOf(table.seat)]}…',
      );
    }
    if (offer != null) {
      final other = table.nicknames[offer.proposedBy];
      return Column(
        children: [
          Text(
            offer.sameCards
                ? '$other propose une revanche avec les mêmes cartes'
                : '$other propose une revanche',
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => controller.answerRematch(accept: true),
            child: const Text('Accepter'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => controller.answerRematch(accept: false),
            child: const Text('Refuser'),
          ),
        ],
      );
    }
    return Column(
      children: [
        FilledButton(
          onPressed: () => controller.proposeRematch(sameCards: false),
          child: const Text('Revanche'),
        ),
        if (sameCardsOption) ...[
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => controller.proposeRematch(sameCards: true),
            child: const Text('Revanche, mêmes cartes'),
          ),
        ],
      ],
    );
  }
}
