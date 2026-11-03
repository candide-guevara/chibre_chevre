import 'dart:math';
import 'dart:ui';

import '../theme/chibre_theme.dart';

/// Drawing helpers for the 1930s "rubber hose" cartoon style: thick ink
/// outlines, pie-cut eyes, white gloves and noodle limbs.

const gold = Color(0xFFE2B33C);
const glove = Color(0xFFFFFFFF);

Paint fillPaint(Color color) => Paint()..color = color;

Paint inkPaint(double width) => Paint()
  ..color = ChibreColors.ink
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeJoin = StrokeJoin.round
  ..strokeCap = StrokeCap.round;

void fillAndInk(Canvas canvas, Path path, Color color, double stroke) {
  canvas.drawPath(path, fillPaint(color));
  canvas.drawPath(path, inkPaint(stroke));
}

Path oval(Offset center, double width, double height) =>
    Path()
      ..addOval(Rect.fromCenter(center: center, width: width, height: height));

/// A white eye with a black pupil missing a wedge, the style's signature.
void pieEye(Canvas canvas, Offset center, double size) {
  fillAndInk(canvas, oval(center, size * 0.8, size), glove, size * 0.08);
  final pupil = Rect.fromCenter(
    center: center + Offset(0, size * 0.12),
    width: size * 0.42,
    height: size * 0.62,
  );
  canvas.drawArc(
    pupil,
    -pi / 2 + 0.5,
    2 * pi - 1.0,
    true,
    fillPaint(ChibreColors.ink),
  );
}

/// A cartoon glove seen from the back, with its cuff.
void whiteGlove(Canvas canvas, Offset center, double size) {
  final stroke = size * 0.1;
  fillAndInk(
    canvas,
    oval(center + Offset(0, size * 0.42), size * 0.6, size * 0.3),
    glove,
    stroke,
  );
  fillAndInk(canvas, oval(center, size, size * 0.9), glove, stroke);
  final fingers = inkPaint(stroke * 0.7);
  for (final dx in [-0.18, 0.0, 0.18]) {
    canvas.drawLine(
      center + Offset(dx * size, -size * 0.38),
      center + Offset(dx * size, -size * 0.1),
      fingers,
    );
  }
}

/// A bendy tube arm from [from] to [to], [bend] pushing its middle sideways.
void noodleArm(
  Canvas canvas,
  Offset from,
  Offset to,
  double bend,
  double width,
) {
  final middle = (from + to) / 2;
  final direction = to - from;
  final normal = Offset(-direction.dy, direction.dx) / direction.distance;
  final path = Path()
    ..moveTo(from.dx, from.dy)
    ..quadraticBezierTo(
      middle.dx + normal.dx * bend,
      middle.dy + normal.dy * bend,
      to.dx,
      to.dy,
    );
  canvas.drawPath(path, inkPaint(width));
}

/// A jaunty beret for the jacks.
void beret(Canvas canvas, Offset bottomCenter, double width, Color color) {
  final path = Path()
    ..moveTo(bottomCenter.dx - width * 0.5, bottomCenter.dy)
    ..quadraticBezierTo(
      bottomCenter.dx - width * 0.55,
      bottomCenter.dy - width * 0.45,
      bottomCenter.dx + width * 0.1,
      bottomCenter.dy - width * 0.42,
    )
    ..quadraticBezierTo(
      bottomCenter.dx + width * 0.6,
      bottomCenter.dy - width * 0.35,
      bottomCenter.dx + width * 0.5,
      bottomCenter.dy,
    )
    ..close();
  fillAndInk(canvas, path, color, width * 0.06);
  fillAndInk(
    canvas,
    oval(
      bottomCenter + Offset(width * 0.1, -width * 0.48),
      width * 0.14,
      width * 0.14,
    ),
    color,
    width * 0.05,
  );
}

/// A crown with [points] spikes; small ones are tiaras for the queens.
void crown(
  Canvas canvas,
  Offset bottomCenter,
  double width,
  double height,
  int points,
) {
  final left = bottomCenter.dx - width / 2;
  final path = Path()..moveTo(left, bottomCenter.dy);
  for (var i = 0; i <= points * 2; i++) {
    final x = left + width * i / (points * 2);
    final y = i.isEven
        ? bottomCenter.dy - height
        : bottomCenter.dy - height * 0.45;
    path.lineTo(x, y);
  }
  path
    ..lineTo(left + width, bottomCenter.dy)
    ..close();
  fillAndInk(canvas, path, gold, width * 0.05);
  for (var i = 0; i <= points; i++) {
    final x = left + width * i / points;
    fillAndInk(
      canvas,
      oval(Offset(x, bottomCenter.dy - height), width * 0.09, width * 0.09),
      ChibreColors.red,
      width * 0.03,
    );
  }
}
