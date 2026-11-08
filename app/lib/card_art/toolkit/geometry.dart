import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

/// Points along an open Catmull-Rom curve through [points].
List<Offset> catmull(List<Offset> points, [int samples = 14]) {
  if (points.length == 2) {
    return [
      for (var i = 0; i <= samples; i++)
        Offset.lerp(points[0], points[1], i / samples)!,
    ];
  }
  final pts = [points.first, ...points, points.last];
  final out = <Offset>[];
  for (var i = 1; i < pts.length - 2; i++) {
    final p0 = pts[i - 1], p1 = pts[i], p2 = pts[i + 1], p3 = pts[i + 2];
    for (var k = 0; k < samples; k++) {
      final t = k / samples, t2 = t * t, t3 = t2 * t;
      double axis(double a, double b, double c, double d) =>
          0.5 *
          (2 * b +
              (-a + c) * t +
              (2 * a - 5 * b + 4 * c - d) * t2 +
              (-a + 3 * b - 3 * c + d) * t3);
      out.add(
        Offset(
          axis(p0.dx, p1.dx, p2.dx, p3.dx),
          axis(p0.dy, p1.dy, p2.dy, p3.dy),
        ),
      );
    }
  }
  out.add(points.last);
  return out;
}

/// A tube through [points] tapering from [w0] to [w1], as a closed shape.
Path noodle(List<Offset> points, double w0, double w1, {bool caps = true}) {
  final pts = catmull(points);
  final n = pts.length - 1;
  final left = <Offset>[], right = <Offset>[];
  final frames = <(Offset, Offset, Offset, double)>[];
  for (var i = 0; i <= n; i++) {
    final p = pts[i];
    final d = pts[min(i + 1, n)] - pts[max(i - 1, 0)];
    final length = d.distance == 0 ? 1.0 : d.distance;
    final dir = d / length;
    final normal = Offset(-dir.dy, dir.dx);
    final w = (w0 + (w1 - w0) * i / n) / 2;
    frames.add((p, dir, normal, w));
    left.add(p + normal * w);
    right.add(p - normal * w);
  }

  List<Offset> cap((Offset, Offset, Offset, double) frame, double sign) {
    final (p, d, normal, w) = frame;
    return [
      for (var k = 1; k < 8; k++)
        p + (normal * cos(pi * k / 8) + d * sin(pi * k / 8)) * (sign * w),
    ];
  }

  return polygon([
    ...left,
    if (caps) ...cap(frames.last, 1),
    ...right.reversed,
    if (caps) ...cap(frames.first, -1),
  ]);
}

Path polygon(List<Offset> points, {bool closed = true}) {
  final path = Path()..moveTo(points.first.dx, points.first.dy);
  for (final p in points.skip(1)) {
    path.lineTo(p.dx, p.dy);
  }
  if (closed) path.close();
  return path;
}

/// A smooth curve through [points] (Catmull-Rom as cubic segments).
Path smooth(List<Offset> points, {bool closed = true, double tension = 0.5}) {
  final n = points.length;
  final path = Path()..moveTo(points.first.dx, points.first.dy);
  final last = closed ? n : n - 1;
  for (var i = 0; i < last; i++) {
    final p0 = closed || i > 0 ? points[(i - 1) % n] : points[i];
    final p1 = points[i];
    final p2 = points[(i + 1) % n];
    final p3 = closed || i + 2 < n ? points[(i + 2) % n] : p2;
    final c1 = p1 + (p2 - p0) * (tension / 3);
    final c2 = p2 - (p3 - p1) * (tension / 3);
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
  }
  if (closed) path.close();
  return path;
}

/// A path of cubic segments, each (control 1, control 2, end).
Path bezier(Offset start, List<(Offset, Offset, Offset)> segments) {
  final path = Path()..moveTo(start.dx, start.dy);
  for (final (c1, c2, end) in segments) {
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
  }
  return path..close();
}

Path ellipse(Offset center, double rx, double ry, [double angle = 0]) {
  final oval = Path()
    ..addOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: 2 * rx,
        height: 2 * max(ry, 0.01),
      ),
    );
  return transformed(oval, dx: center.dx, dy: center.dy, angle: angle);
}

Path circle(Offset center, double r) => ellipse(center, r, r);

Path rectangle(double x, double y, double w, double h) =>
    Path()..addRect(Rect.fromLTWH(x, y, w, h));

Path union(List<Path> paths) {
  final out = Path();
  for (final p in paths) {
    out.addPath(p, Offset.zero);
  }
  return out;
}

/// [path] scaled by ([sx], [sy]) and rotated by [angle] about [about], then
/// moved by ([dx], [dy]).
Path transformed(
  Path path, {
  double dx = 0,
  double dy = 0,
  double sx = 1,
  double? sy,
  double angle = 0,
  Offset about = Offset.zero,
}) {
  final syy = sy ?? sx;
  final c = cos(angle), s = sin(angle);
  final a = sx * c, b = sx * s, cc = -syy * s, d = syy * c;
  final tx = dx + about.dx - (a * about.dx + cc * about.dy);
  final ty = dy + about.dy - (b * about.dx + d * about.dy);
  return path.transform(
    Float64List.fromList([a, b, 0, 0, cc, d, 0, 0, 0, 0, 1, 0, tx, ty, 0, 1]),
  );
}

Offset lerp(Offset a, Offset b, double t) => Offset.lerp(a, b, t)!;

double angleOf(Offset a, Offset b) => atan2(b.dy - a.dy, b.dx - a.dx);

Offset at(Offset origin, double angle, double distance) =>
    origin + Offset(cos(angle), sin(angle)) * distance;

double radians(double degrees) => degrees * pi / 180;
