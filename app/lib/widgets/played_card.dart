import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/widgets.dart';

import 'playing_card.dart';
import 'table_position.dart';

/// A card of the trick, sliding in from the side of the player who played
/// it when it first appears.
class PlayedCard extends StatelessWidget {
  const PlayedCard({
    super.key,
    required this.card,
    required this.width,
    required this.from,
  });

  final Card card;
  final double width;
  final TablePosition from;

  static const _duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final distance = Offset(width * 2.5, width * cardAspectRatio * 2);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: _duration,
      curve: Curves.easeOut,
      builder: (context, remaining, child) => Transform.translate(
        offset:
            Offset(
              from.direction.dx * distance.dx,
              from.direction.dy * distance.dy,
            ) *
            remaining,
        child: child,
      ),
      child: PlayingCard(card: card, width: width),
    );
  }
}
