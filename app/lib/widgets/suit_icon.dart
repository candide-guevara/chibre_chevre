import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/widgets.dart';

import '../card_art/suit_symbol.dart';

/// A suit drawn like on the cards (red diamonds and hearts, black spades and
/// clubs), independent of the fonts available.
class SuitIcon extends StatelessWidget {
  const SuitIcon(this.suit, {super.key, required this.size});

  final Suit suit;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _SuitPainter(suit));
}

class _SuitPainter extends CustomPainter {
  const _SuitPainter(this.suit);

  final Suit suit;

  @override
  void paint(Canvas canvas, Size size) =>
      paintSuit(canvas, suit, Offset.zero & size);

  @override
  bool shouldRepaint(_SuitPainter old) => old.suit != suit;
}
