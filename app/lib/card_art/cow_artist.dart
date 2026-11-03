import 'dart:ui';

import '../theme/chibre_theme.dart';
import 'face_artist.dart';
import 'rubber_hose.dart';

const _hide = Color(0xFFFFFFFF);
const _muzzle = Color(0xFFF4A7B0);
const _horn = Color(0xFFF2E6C4);

class CowArtist extends FaceArtist {
  const CowArtist();

  @override
  Offset paintHead(Canvas canvas, Offset c, double s) {
    final stroke = s * 0.05;
    for (final side in [-1.0, 1.0]) {
      final horn = Path()
        ..moveTo(c.dx + side * s * 0.18, c.dy - s * 0.36)
        ..quadraticBezierTo(
          c.dx + side * s * 0.42,
          c.dy - s * 0.4,
          c.dx + side * s * 0.38,
          c.dy - s * 0.58,
        )
        ..quadraticBezierTo(
          c.dx + side * s * 0.3,
          c.dy - s * 0.42,
          c.dx + side * s * 0.1,
          c.dy - s * 0.4,
        )
        ..close();
      fillAndInk(canvas, horn, _horn, stroke);
      final ear = c + Offset(side * s * 0.46, -s * 0.16);
      fillAndInk(canvas, oval(ear, s * 0.32, s * 0.15), _hide, stroke);
      canvas.drawPath(oval(ear, s * 0.18, s * 0.06), fillPaint(_muzzle));
    }

    final head = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c, width: s * 0.74, height: s * 0.86),
          Radius.circular(s * 0.3),
        ),
      );
    canvas.drawPath(head, fillPaint(_hide));
    canvas.save();
    canvas.clipPath(head);
    canvas.drawPath(
      oval(c + Offset(-s * 0.26, -s * 0.26), s * 0.34, s * 0.26),
      fillPaint(ChibreColors.ink),
    );
    canvas.drawPath(
      oval(c + Offset(s * 0.3, s * 0.02), s * 0.22, s * 0.32),
      fillPaint(ChibreColors.ink),
    );
    canvas.restore();
    canvas.drawPath(head, inkPaint(stroke));

    fillAndInk(
      canvas,
      oval(c + Offset(0, s * 0.24), s * 0.6, s * 0.32),
      _muzzle,
      stroke,
    );
    for (final side in [-1.0, 1.0]) {
      canvas.drawPath(
        oval(c + Offset(side * s * 0.12, s * 0.22), s * 0.07, s * 0.1),
        fillPaint(const Color(0xFF8C3A47)),
      );
    }
    pieEye(canvas, c + Offset(-s * 0.15, -s * 0.08), s * 0.2);
    pieEye(canvas, c + Offset(s * 0.15, -s * 0.08), s * 0.2);
    return c + Offset(0, -s * 0.4);
  }
}
