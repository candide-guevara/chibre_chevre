import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/widgets.dart';

import 'playing_card.dart';

/// The player's cards at the bottom of the screen, overlapping to fit the
/// width. Cards outside [enabled] are dimmed and can't be tapped. A [badge]
/// (e.g. the Stöck button) can be shown above one card.
class HandView extends StatelessWidget {
  const HandView({
    super.key,
    required this.cards,
    required this.enabled,
    this.selected = CardSet.empty,
    required this.onTap,
    this.badge,
  });

  /// Room above the cards for the badge, always kept so the hand never moves.
  static const badgeHeight = 40.0;

  final List<Card> cards;
  final CardSet enabled;
  final CardSet selected;
  final void Function(Card card) onTap;
  final ({Card card, Widget child})? badge;

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
      final cardHeight = cardWidth * cardAspectRatio;
      final badgeIndex = badge == null ? -1 : cards.indexOf(badge!.card);
      return SizedBox(
        width: width,
        height: cardHeight + badgeHeight,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            for (final (index, card) in cards.indexed)
              Positioned(
                left: index * step,
                bottom: 0,
                child: PlayingCard(
                  card: card,
                  width: cardWidth,
                  enabled: enabled.contains(card),
                  selected: selected.contains(card),
                  onTap: () => onTap(card),
                ),
              ),
            if (badgeIndex >= 0)
              Positioned(
                left: badgeIndex * step,
                width: cardWidth,
                bottom: cardHeight,
                height: badgeHeight,
                child: Center(child: badge!.child),
              ),
          ],
        ),
      );
    },
  );
}
