import 'dart:math';
import 'dart:ui';

import '../toolkit/geometry.dart';
import '../toolkit/ink.dart';
import 'toon.dart';

const _white = Color(0xFFFFFFFF);

List<Offset> _scaled(List<(double, double)> points, double s) => [
  for (final (x, y) in points) Offset(x * s, y * s),
];

/// A four fingered glove at [wrist]. The fingers point along [angle]; [thumb]
/// picks the side the thumb sits on.
void hand(
  Canvas canvas,
  Offset wrist,
  double angle,
  double size,
  HandPose pose,
  Look look, {
  Color color = paperWhite,
  int thumb = 1,
}) {
  canvas.save();
  canvas.translate(wrist.dx, wrist.dy);
  canvas.rotate(angle - pi / 2);
  if (thumb < 0) canvas.scale(-1, 1);
  final s = size;
  final lw = look.lw * 0.85;
  const shade = 0.14;
  void glove(Path shape) =>
      part(canvas, shape, color, look, shade: shade, lw: lw);

  void finger(Offset base, double a, double length, double w) {
    final tip = base + Offset(sin(-a) * length, cos(a) * length);
    glove(noodle([base, lerp(base, tip, 0.55), tip], w, w * 0.92));
  }

  final palm = ellipse(Offset(0, 0.48 * s), 0.4 * s, 0.38 * s);
  switch (pose) {
    case HandPose.open:
      for (final (i, a) in [-0.42, -0.14, 0.14].indexed) {
        finger(
          Offset(-0.14 * s + i * 0.14 * s, 0.55 * s),
          a,
          0.62 * s,
          0.24 * s,
        );
      }
      finger(Offset(0.3 * s, 0.4 * s), -1.15, 0.42 * s, 0.24 * s);
      glove(palm);
    case HandPose.limp:
      for (final (i, _) in [0.42, 0.28, 0.14].indexed) {
        final base = Offset(-0.18 * s + i * 0.12 * s, 0.6 * s);
        final tip = base + Offset(-0.12 * s + i * 0.04 * s, 0.55 * s);
        final bend = base + Offset(0.12 * s, 0.32 * s);
        glove(noodle([base, bend, tip], 0.22 * s, 0.2 * s));
      }
      finger(Offset(0.28 * s, 0.45 * s), -0.7, 0.36 * s, 0.22 * s);
      glove(palm);
    case HandPose.fist || HandPose.grip || HandPose.hip || HandPose.point:
      final fist = smooth(
        _scaled([
          (-0.42, 0.2),
          (0.36, 0.16),
          (0.46, 0.6),
          (0.2, 0.9),
          (-0.3, 0.88),
          (-0.48, 0.55),
        ], s),
        tension: 0.45,
      );
      if (pose == HandPose.point) {
        glove(
          noodle(
            _scaled([(-0.2, 0.7), (-0.24, 1.15), (-0.24, 1.45)], s),
            0.24 * s,
            0.22 * s,
          ),
        );
      }
      glove(fist);
      for (var k = 0; k < (pose == HandPose.point ? 2 : 3); k++) {
        final x = -0.02 * s + k * 0.17 * s;
        line(
          canvas,
          [
            Offset(x, 0.5 * s),
            Offset(x + 0.02 * s, 0.72 * s),
            Offset(x + 0.06 * s, 0.86 * s),
          ],
          look,
          lw * 0.8,
        );
      }
      glove(
        noodle(
          _scaled([(0.34, 0.32), (0.2, 0.56), (-0.05, 0.62)], s),
          0.22 * s,
          0.2 * s,
        ),
      );
  }
  final cuff = smooth(
    _scaled([
      (-0.36, -0.42),
      (0.36, -0.42),
      (0.27, 0.1),
      (0, 0.14),
      (-0.27, 0.1),
    ], s),
    tension: 0.25,
  );
  part(canvas, cuff, color, look, shade: 0.1, lw: lw);
  strokePath(
    canvas,
    smooth(_scaled([(-0.3, -0.24), (0, -0.2), (0.3, -0.24)], s), closed: false),
    alpha(look.ink, 0.7),
    lw * 0.6,
  );
  canvas.restore();
}

/// A big cartoon shoe, a pump or a riding boot at [ankle].
void shoe(
  Canvas canvas,
  Offset ankle,
  int facing,
  double size,
  ShoeKind kind,
  Color color,
  Look look, {
  double tilt = 0,
  Color? accent,
}) {
  canvas.save();
  canvas.translate(ankle.dx, ankle.dy);
  canvas.rotate(tilt * facing);
  canvas.scale(facing.toDouble(), 1);
  final s = size;
  switch (kind) {
    case ShoeKind.round:
      final body = smooth(
        _scaled([
          (-0.32, -0.18),
          (0.18, -0.3),
          (0.72, -0.22),
          (1.06, 0.06),
          (0.92, 0.36),
          (0.2, 0.4),
          (-0.38, 0.34),
          (-0.46, 0.08),
        ], s),
      );
      part(canvas, body, color, look, shade: 0.2);
      line(
        canvas,
        _scaled([(-0.4, 0.26), (0.3, 0.32), (0.98, 0.24)], s),
        look,
        look.lw * 0.7,
        alpha(lighter(color, 0.5), 0.9),
      );
      fillPath(
        canvas,
        ellipse(Offset(0.66 * s, -0.08 * s), 0.17 * s, 0.07 * s, 0.25),
        alpha(_white, 0.75),
      );
    case ShoeKind.heel:
      final heel = polygon(
        _scaled([(-0.32, 0.1), (-0.14, 0.12), (-0.2, 0.62), (-0.27, 0.62)], s),
      );
      part(canvas, heel, darker(color, 0.25), look, shade: 0);
      final body = smooth(
        _scaled([
          (-0.38, -0.12),
          (-0.08, -0.08),
          (0.4, 0.22),
          (0.86, 0.5),
          (0.88, 0.66),
          (0.5, 0.66),
          (0.05, 0.38),
          (-0.36, 0.22),
        ], s),
        tension: 0.42,
      );
      part(canvas, body, color, look, shade: 0.2);
      if (accent != null) {
        part(
          canvas,
          ellipse(Offset(0.2 * s, 0.14 * s), 0.13 * s, 0.09 * s, 0.6),
          accent,
          look,
          shade: 0,
          lw: look.lw * 0.6,
        );
      }
      fillPath(
        canvas,
        ellipse(Offset(0.55 * s, 0.4 * s), 0.12 * s, 0.05 * s, 0.6),
        alpha(_white, 0.7),
      );
    case ShoeKind.boot:
      final shaft = smooth(
        _scaled([(-0.36, -0.95), (0.34, -0.95), (0.28, -0.1), (-0.3, -0.1)], s),
        tension: 0.15,
      );
      final body = smooth(
        _scaled([
          (-0.36, -0.5),
          (0.3, -0.4),
          (0.6, -0.08),
          (1.05, 0.1),
          (1.02, 0.34),
          (0.2, 0.38),
          (-0.4, 0.34),
          (-0.44, 0.0),
        ], s),
        tension: 0.45,
      );
      part(canvas, union([shaft, body]), color, look, shade: 0.2);
      part(
        canvas,
        polygon(
          _scaled([(-0.4, 0.2), (-0.12, 0.2), (-0.14, 0.4), (-0.4, 0.4)], s),
        ),
        darker(color, 0.4),
        look,
        shade: 0,
      );
      final top = smooth(
        _scaled([
          (-0.42, -1.06),
          (0.4, -1.06),
          (0.36, -0.86),
          (-0.38, -0.86),
        ], s),
        tension: 0.2,
      );
      part(canvas, top, accent ?? darker(color, 0.3), look, shade: 0);
      fillPath(
        canvas,
        ellipse(Offset(0.62 * s, 0.02 * s), 0.16 * s, 0.06 * s, 0.3),
        alpha(_white, 0.7),
      );
  }
  canvas.restore();
}

/// A tall pie-cut eye with an optional heavy lid.
void eye(
  Canvas canvas,
  Offset center,
  double w,
  double h,
  Offset lookDir,
  Look look, {
  double lid = 0,
  double lidAngle = 0,
  Color skin = paperWhite,
  int lashes = 0,
  int side = 1,
}) {
  final x = center.dx, y = center.dy;
  final shape = ellipse(center, w, h);
  part(canvas, shape, paperWhite, look, shade: 0.05, lw: look.lw * 0.8);
  canvas.save();
  canvas.clipPath(shape);
  final pupil = Path()
    ..moveTo(0, 0)
    ..arcTo(
      Rect.fromCircle(center: Offset.zero, radius: 1),
      -0.22 * pi,
      1.7 * pi,
      false,
    )
    ..close();
  fillPath(
    canvas,
    transformed(
      pupil,
      dx: x + lookDir.dx * w * 0.45,
      dy: y + h * 0.18 + lookDir.dy * h * 0.3,
      sx: w * 0.55,
      sy: h * 0.6,
    ),
    look.ink,
  );
  if (lid > 0) {
    final top = y - h - 4;
    final edge = y - h + 2 * h * lid;
    canvas.save();
    canvas.translate(x, edge);
    canvas.rotate(lidAngle * side);
    fillPath(
      canvas,
      polygon([
        Offset(-w * 2, top - edge - 20),
        Offset(w * 2, top - edge - 20),
        Offset(w * 2, 0),
        Offset(-w * 2, 0),
      ]),
      skin,
    );
    strokePath(
      canvas,
      polygon([Offset(-w * 2, 0), Offset(w * 2, 0)], closed: false),
      look.ink,
      look.lw * 1.3,
    );
    canvas.restore();
  }
  canvas.restore();
  strokePath(canvas, shape, look.ink, look.lw * 0.8 * 2);
  for (var i = 0; i < lashes; i++) {
    final a = radians(side > 0 ? -80.0 + i * 26 : -100.0 - i * 26);
    var base = Offset(x + cos(a) * w * 0.98, y + sin(a) * h * 0.98);
    if (lid > 0) base = Offset(base.dx, max(base.dy, y - h + 2 * h * lid - 1));
    final length = h * (0.62 - i * 0.08);
    final tip =
        base + Offset(cos(a) * length + side * length * 0.3, sin(a) * length);
    brush(canvas, [base, lerp(base, tip, 0.5), tip], look.lw * 1.6, 0.6, look);
  }
}
