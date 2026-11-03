import 'dart:ui';

import '../theme/chibre_theme.dart';
import 'face_artist.dart';
import 'rubber_hose.dart';

const _coat = Color(0xFFFFFFFF);
const _muzzle = Color(0xFF3A3A3A);

class ZebraArtist extends FaceArtist {
  const ZebraArtist();

  @override
  Offset paintHead(Canvas canvas, Offset c, double s) {
    final stroke = s * 0.05;
    for (final side in [-1.0, 1.0]) {
      final ear = c + Offset(side * s * 0.2, -s * 0.46);
      fillAndInk(canvas, oval(ear, s * 0.14, s * 0.3), _coat, stroke);
      canvas.drawPath(
        oval(ear, s * 0.05, s * 0.16),
        fillPaint(ChibreColors.ink),
      );
    }
    final mane = Path()..moveTo(c.dx - s * 0.1, c.dy - s * 0.42);
    for (var i = 0; i < 4; i++) {
      final x = c.dx - s * 0.1 + s * 0.2 * (i + 0.5) / 4;
      mane
        ..lineTo(x, c.dy - s * 0.6)
        ..lineTo(c.dx - s * 0.1 + s * 0.2 * (i + 1) / 4, c.dy - s * 0.42);
    }
    fillAndInk(canvas, mane..close(), ChibreColors.ink, stroke * 0.5);

    final head = oval(c + Offset(0, s * 0.04), s * 0.62, s * 0.94);
    canvas.drawPath(head, fillPaint(_coat));
    canvas.save();
    canvas.clipPath(head);
    final stripes = inkPaint(s * 0.07);
    for (var i = 0; i < 4; i++) {
      final y = c.dy - s * 0.34 + i * s * 0.12;
      for (final side in [-1.0, 1.0]) {
        final stripe = Path()
          ..moveTo(c.dx + side * s * 0.35, y + s * 0.06)
          ..quadraticBezierTo(
            c.dx + side * s * 0.2,
            y - s * 0.04,
            c.dx + side * s * 0.06,
            y,
          );
        canvas.drawPath(stripe, stripes);
      }
    }
    canvas.restore();
    canvas.drawPath(head, inkPaint(stroke));

    fillAndInk(
      canvas,
      oval(c + Offset(0, s * 0.32), s * 0.5, s * 0.32),
      _muzzle,
      stroke,
    );
    for (final side in [-1.0, 1.0]) {
      canvas.drawPath(
        oval(c + Offset(side * s * 0.1, s * 0.3), s * 0.06, s * 0.08),
        fillPaint(const Color(0xFF777777)),
      );
    }
    pieEye(canvas, c + Offset(-s * 0.14, -s * 0.06), s * 0.2);
    pieEye(canvas, c + Offset(s * 0.14, -s * 0.06), s * 0.2);
    return c + Offset(0, -s * 0.42);
  }
}
