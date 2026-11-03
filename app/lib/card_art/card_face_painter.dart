import 'dart:math';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/rendering.dart';

import '../labels.dart';
import '../theme/chibre_theme.dart';
import 'face_artist.dart';
import 'pip_layout.dart';
import 'suit_symbol.dart';

/// Paints the front of [card] with the [style] face cards.
class CardFacePainter extends CustomPainter {
  const CardFacePainter(this.card, this.style);

  final Card card;
  final CardStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final outline = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(w * 0.08),
    );
    canvas.drawRRect(outline, Paint()..color = ChibreColors.ivory);
    canvas.drawRRect(
      outline,
      Paint()
        ..color = const Color(0xFF9AA39E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(1, w * 0.012),
    );

    _paintIndex(canvas, size);
    canvas.save();
    canvas.translate(w, h);
    canvas.rotate(pi);
    _paintIndex(canvas, size);
    canvas.restore();

    switch (card.rank) {
      case Rank.ace:
        final symbol = w * 0.46;
        paintSuit(
          canvas,
          card.suit,
          Rect.fromCenter(
            center: size.center(Offset.zero),
            width: symbol,
            height: symbol,
          ),
        );
      case Rank.jack || Rank.queen || Rank.king:
        canvas.save();
        final area = Rect.fromLTRB(w * 0.16, h * 0.1, w * 0.84, h * 0.9);
        canvas.clipRect(area);
        faceArtistFor(style).paintFigure(canvas, area, card.rank, card.suit);
        canvas.restore();
      default:
        _paintPips(canvas, size);
    }
  }

  void _paintIndex(Canvas canvas, Size size) {
    final w = size.width;
    final text = TextPainter(
      text: TextSpan(
        text: rankIndex(card.rank),
        style: TextStyle(
          color: suitColor(card.suit),
          fontSize: w * 0.19,
          fontWeight: FontWeight.w700,
          height: 1,
          letterSpacing: card.rank == Rank.ten ? -w * 0.02 : 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final x = w * 0.11 - text.width / 2 + w * 0.02;
    text.paint(canvas, Offset(max(w * 0.02, x), w * 0.06));
    final symbol = w * 0.13;
    paintSuit(
      canvas,
      card.suit,
      Rect.fromLTWH(w * 0.065, w * 0.08 + text.height, symbol, symbol),
    );
  }

  void _paintPips(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final area = Rect.fromLTRB(w * 0.34, h * 0.18, w * 0.66, h * 0.82);
    final pip = w * 0.17;
    for (final position in pipPositions(card.rank)) {
      final center = Offset(
        area.left + area.width * position.dx,
        area.top + area.height * position.dy,
      );
      final box = Rect.fromCenter(center: center, width: pip, height: pip);
      if (position.dy > 0.5) {
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(pi);
        canvas.translate(-center.dx, -center.dy);
        paintSuit(canvas, card.suit, box);
        canvas.restore();
      } else {
        paintSuit(canvas, card.suit, box);
      }
    }
  }

  @override
  bool shouldRepaint(CardFacePainter oldDelegate) =>
      oldDelegate.card != card || oldDelegate.style != style;
}
