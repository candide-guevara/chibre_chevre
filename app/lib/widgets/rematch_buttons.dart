import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/game_controller.dart';
import '../strings.dart';

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
        Strings.waitingForAnswer(table.nicknames[partnerOf(table.seat)]),
      );
    }
    if (offer != null) {
      final other = table.nicknames[offer.proposedBy];
      return Column(
        children: [
          Text(Strings.proposesRematch(other, sameCards: offer.sameCards)),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => controller.answerRematch(accept: true),
            child: const Text(Strings.accept),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => controller.answerRematch(accept: false),
            child: const Text(Strings.refuse),
          ),
        ],
      );
    }
    return Column(
      children: [
        FilledButton(
          onPressed: () => controller.proposeRematch(sameCards: false),
          child: const Text(Strings.rematch),
        ),
        if (sameCardsOption) ...[
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => controller.proposeRematch(sameCards: true),
            child: const Text(Strings.rematchSameCards),
          ),
        ],
      ],
    );
  }
}
