import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/widgets.dart';

import 'playing_card.dart';

/// Where a seat sits on screen, seen from [viewer] (always at the bottom).
/// Play is counter-clockwise, so the next seat is on the right.
enum TablePosition { bottom, right, top, left }

TablePosition positionOf(int seat, int viewer) =>
    TablePosition.values[(seat - viewer) % seatCount];

/// The cards of a trick, each in front of the seat that played it.
class TrickView extends StatelessWidget {
  const TrickView({
    super.key,
    required this.trick,
    required this.viewer,
    required this.style,
    required this.cardWidth,
  });

  final Trick trick;
  final int viewer;
  final CardStyle style;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final height = cardWidth * cardAspectRatio;
    return SizedBox(
      width: cardWidth * 3.2,
      height: height * 2.3,
      child: Stack(
        children: [
          for (final (position, card) in trick.cards.indexed)
            Align(
              alignment: switch (positionOf(trick.seatAt(position), viewer)) {
                TablePosition.bottom => Alignment.bottomCenter,
                TablePosition.right => Alignment.centerRight,
                TablePosition.top => Alignment.topCenter,
                TablePosition.left => Alignment.centerLeft,
              },
              child: PlayingCard(card: card, style: style, width: cardWidth),
            ),
        ],
      ),
    );
  }
}
