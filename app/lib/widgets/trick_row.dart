import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart' hide Card;

import 'playing_card.dart';

/// A trick laid out in a row, in play order, with who played each card. The
/// winner's card is highlighted once the trick is complete.
class TrickRow extends StatelessWidget {
  const TrickRow({
    super.key,
    required this.number,
    required this.trick,
    required this.nicknames,
    required this.style,
    this.winner,
  });

  final int number;
  final Trick trick;
  final List<String> nicknames;
  final CardStyle style;
  final int? winner;

  static const _cardWidth = 56.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 48,
            child: Text('Pli $number', style: text.labelLarge),
          ),
          for (final (index, card) in trick.cards.indexed)
            Expanded(
              child: Column(
                children: [
                  PlayingCard(
                    card: card,
                    style: style,
                    width: _cardWidth,
                    selected: trick.seatAt(index) == winner,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nicknames[trick.seatAt(index)],
                    style: text.labelSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          for (var i = trick.cards.length; i < seatCount; i++) const Spacer(),
        ],
      ),
    );
  }
}
