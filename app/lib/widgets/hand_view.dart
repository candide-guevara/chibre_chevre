import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/widgets.dart';

import 'playing_card.dart';

/// The player's cards at the bottom of the screen, overlapping to fit the
/// width. Cards outside [enabled] are dimmed and can't be tapped.
class HandView extends StatelessWidget {
  const HandView({
    super.key,
    required this.cards,
    required this.style,
    required this.enabled,
    this.selected = CardSet.empty,
    required this.onTap,
  });

  final List<Card> cards;
  final CardStyle style;
  final CardSet enabled;
  final CardSet selected;
  final void Function(Card card) onTap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      if (cards.isEmpty) return const SizedBox.shrink();
      final cardWidth = min(90.0, box.maxWidth / 4.2);
      final step = cards.length == 1
          ? 0.0
          : min(
              cardWidth * 1.05,
              (box.maxWidth - cardWidth) / (cards.length - 1),
            );
      final width = cardWidth + step * (cards.length - 1);
      return SizedBox(
        width: width,
        height: cardWidth * cardAspectRatio * 1.2,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            for (final (index, card) in cards.indexed)
              Positioned(
                left: index * step,
                bottom: 0,
                child: PlayingCard(
                  card: card,
                  style: style,
                  width: cardWidth,
                  enabled: enabled.contains(card),
                  selected: selected.contains(card),
                  onTap: () => onTap(card),
                ),
              ),
          ],
        ),
      );
    },
  );
}
