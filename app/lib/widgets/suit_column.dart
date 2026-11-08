import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/widgets.dart';

import 'playing_card.dart';
import 'suit_icon.dart';

/// The cards of one suit, under its symbol, overlapping from top to bottom
/// so that each card's corner stays visible.
class SuitColumn extends StatelessWidget {
  const SuitColumn({super.key, required this.suit, required this.cards});

  final Suit suit;

  /// In display order, top to bottom.
  final List<Card> cards;

  /// How much of each card shows above the next one.
  static const _visible = 0.32;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final width = min(box.maxWidth, 80.0);
      final height = width * cardAspectRatio;
      final step = height * _visible;
      return Column(
        children: [
          SuitIcon(suit, size: 28),
          const SizedBox(height: 8),
          SizedBox(
            width: width,
            height: cards.isEmpty ? 0 : height + step * (cards.length - 1),
            child: Stack(
              children: [
                for (final (index, card) in cards.indexed)
                  Positioned(
                    top: index * step,
                    child: PlayingCard(card: card, width: width),
                  ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
