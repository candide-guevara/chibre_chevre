import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'hand_layout.dart';

/// A row lined up with a hand stacked under it, bottom aligned: one column
/// per card, as wide as the visible part of that card, with [child]
/// centered in the column of [card] (it may be wider than the column). The
/// row ends at the top of the cards.
class HandColumns extends StatelessWidget {
  const HandColumns({
    super.key,
    required this.cards,
    required this.card,
    required this.child,
  });

  /// The cards of the hand, in the order they are shown.
  final List<Card> cards;
  final Card card;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final layout = HandLayout(box.maxWidth, cards.length);
      final column = cards.indexOf(card);
      return Padding(
        padding: EdgeInsets.only(bottom: layout.cardHeight),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < cards.length; index++)
              SizedBox(
                width: layout.columnWidth(index),
                child: index == column
                    ? OverflowBox(
                        maxWidth: double.infinity,
                        fit: OverflowBoxFit.deferToChild,
                        child: child,
                      )
                    : null,
              ),
          ],
        ),
      );
    },
  );
}
