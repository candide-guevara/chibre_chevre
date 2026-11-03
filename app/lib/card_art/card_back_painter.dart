import 'package:flutter/rendering.dart';

import '../theme/chibre_theme.dart';

/// The back of the cards: felt green with a thin ivory lattice.
class CardBackPainter extends CustomPainter {
  const CardBackPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final outer = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(w * 0.08),
    );
    canvas.drawRRect(outer, Paint()..color = ChibreColors.ivory);
    final inner = outer.deflate(w * 0.07);
    canvas.drawRRect(inner, Paint()..color = ChibreColors.felt);
    canvas.save();
    canvas.clipRRect(inner);
    final line = Paint()
      ..color = ChibreColors.feltLight
      ..strokeWidth = w * 0.025;
    final step = w * 0.18;
    for (var x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), line);
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), line);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CardBackPainter oldDelegate) => false;
}
