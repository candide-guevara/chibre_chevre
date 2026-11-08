import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/rendering.dart';

import 'card_design.dart';
import 'card_images.dart';

/// Paints the front of [card] from [deck], scaled to the canvas: its bitmap
/// when loaded, else its vector drawing. Repaints when the bitmap arrives.
class CardFacePainter extends CustomPainter {
  CardFacePainter(this.card, this.deck) : super(repaint: deck);

  final Card card;
  final CardImages deck;

  static final _imagePaint = Paint()..filterQuality = FilterQuality.medium;

  @override
  void paint(Canvas canvas, Size size) {
    final image = deck.image(card);
    if (image != null) {
      canvas.drawImageRect(
        image,
        Offset.zero & Size(image.width.toDouble(), image.height.toDouble()),
        Offset.zero & size,
        _imagePaint,
      );
      return;
    }
    canvas.save();
    canvas.scale(
      size.width / cardDesignSize.width,
      size.height / cardDesignSize.height,
    );
    canvas.drawPicture(deck.picture(card));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CardFacePainter oldDelegate) =>
      oldDelegate.card != card || oldDelegate.deck != deck;
}
