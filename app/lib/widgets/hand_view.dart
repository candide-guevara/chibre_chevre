import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/widgets.dart';

import 'hand_layout.dart';
import 'playing_card.dart';

/// The player's cards at the bottom of the screen, overlapping to fit the
/// width. Cards outside [enabled] are dimmed and can't be tapped.
class HandView extends StatelessWidget {
  const HandView({
    super.key,
    required this.cards,
    required this.enabled,
    this.selected = CardSet.empty,
    required this.onTap,
  });

  final List<Card> cards;
  final CardSet enabled;
  final CardSet selected;
  final void Function(Card card) onTap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      if (cards.isEmpty) return const SizedBox.shrink();
      final layout = HandLayout(box.maxWidth, cards.length);
      return SizedBox(
        width: layout.width,
        height: layout.height,
        child: Stack(
          children: [
            for (final (index, card) in cards.indexed)
              Positioned(
                left: index * layout.step,
                bottom: 0,
                child: PlayingCard(
                  card: card,
                  width: layout.cardWidth,
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
