import 'dart:ui';

import 'face_artist.dart';
import 'rubber_hose.dart';

const _fur = Color(0xFF7A4A2A);
const _skin = Color(0xFFF1C79C);

class MonkeyArtist extends FaceArtist {
  const MonkeyArtist();

  @override
  Offset paintHead(Canvas canvas, Offset c, double s) {
    final stroke = s * 0.05;
    for (final side in [-1.0, 1.0]) {
      final ear = c + Offset(side * s * 0.46, 0);
      fillAndInk(canvas, oval(ear, s * 0.34, s * 0.34), _fur, stroke);
      canvas.drawPath(oval(ear, s * 0.18, s * 0.18), fillPaint(_skin));
    }
    fillAndInk(canvas, oval(c, s * 0.84, s * 0.84), _fur, stroke);

    final face = Path()
      ..addOval(
        Rect.fromCircle(
          center: c + Offset(-s * 0.13, -s * 0.06),
          radius: s * 0.17,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: c + Offset(s * 0.13, -s * 0.06),
          radius: s * 0.17,
        ),
      )
      ..addOval(
        Rect.fromCenter(
          center: c + Offset(0, s * 0.17),
          width: s * 0.56,
          height: s * 0.34,
        ),
      );
    canvas.drawPath(face, fillPaint(_skin));

    pieEye(canvas, c + Offset(-s * 0.12, -s * 0.07), s * 0.2);
    pieEye(canvas, c + Offset(s * 0.12, -s * 0.07), s * 0.2);
    for (final side in [-1.0, 1.0]) {
      canvas.drawCircle(
        c + Offset(side * s * 0.04, s * 0.1),
        s * 0.02,
        fillPaint(const Color(0xFF3B2414)),
      );
    }
    final smile = Path()
      ..moveTo(c.dx - s * 0.16, c.dy + s * 0.17)
      ..quadraticBezierTo(
        c.dx,
        c.dy + s * 0.32,
        c.dx + s * 0.16,
        c.dy + s * 0.17,
      );
    canvas.drawPath(smile, inkPaint(stroke));
    return c + Offset(0, -s * 0.36);
  }
}
