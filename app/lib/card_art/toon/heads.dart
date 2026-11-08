import 'dart:math';
import 'dart:ui';

import '../toolkit/geometry.dart';
import '../toolkit/ink.dart';
import 'parts.dart';
import 'toon.dart';

/// The head size unit.
const headUnit = 56.0;
const _u = headUnit;
const _white = Color(0xFFFFFFFF);

/// Paints the head in side view, the snout pointing the way the pose faces.
void paintHead(Canvas canvas, Toon t, Look look) {
  final p = t.pose;
  canvas.save();
  canvas.translate(p.head.dx, p.head.dy);
  canvas.rotate(radians(p.tilt));
  if (p.face < 0) canvas.scale(-1, 1);
  switch (t.animal) {
    case Animal.cow:
      _cow(canvas, t, look);
    case Animal.dog:
      _dog(canvas, t, look);
    case Animal.monkey:
      _monkey(canvas, t, look);
    case Animal.zebra:
      _zebra(canvas, t, look);
  }
  canvas.restore();
}

/// Points given in head units.
List<Offset> _h(List<(double, double)> points) => [
  for (final (x, y) in points) Offset(x * _u, y * _u),
];

Offset _o(double x, double y) => Offset(x * _u, y * _u);

void _highlight(
  Canvas canvas,
  Offset c,
  double rx,
  double ry, [
  double angle = 0,
]) => fillPath(canvas, ellipse(c, rx, ry, angle), alpha(_white, 0.55));

const _lid = {
  Expression.smug: 0.38,
  Expression.sly: 0.42,
  Expression.sultry: 0.48,
  Expression.grin: 0.08,
  Expression.proud: 0.26,
};
const _lidAngle = {
  Expression.smug: -0.12,
  Expression.sly: 0.2,
  Expression.sultry: -0.16,
  Expression.grin: 0.0,
  Expression.proud: -0.12,
};

/// Two eyes (the far one narrower, behind), brows and a mouth running from
/// the front of the snout back to its corner.
void _features(
  Canvas canvas,
  Toon t,
  Look look, {
  required Offset near,
  required Offset far,
  required double ew,
  required double eh,
  required Color skin,
  required Offset front,
  required Offset corner,
  Color? mouthInk,
  bool brows = true,
}) {
  final ex = t.expression;
  final lookDir = Offset(0.55, t.lookDir.dy);
  for (final (c, w) in [(far, ew * 0.78), (near, ew)]) {
    eye(
      canvas,
      c,
      w,
      eh,
      lookDir,
      look,
      lid: _lid[ex]!,
      lidAngle: _lidAngle[ex]!,
      skin: skin,
      lashes: t.lashes,
    );
  }
  if (brows) {
    final raise = switch (ex) {
      Expression.sly => -0.08 * _u,
      Expression.proud => -0.05 * _u,
      Expression.grin => -0.06 * _u,
      _ => 0.0,
    };
    for (final (c, w) in [(far, ew * 0.78), (near, ew)]) {
      final by = c.dy - eh - 0.13 * _u;
      brush(
        canvas,
        [
          Offset(c.dx - w * 0.9, by + 0.05 * _u),
          Offset(c.dx, by - 0.03 * _u + raise),
          Offset(c.dx + w * 0.9, by + 0.02 * _u + raise * 0.5),
        ],
        look.lw * 1.5,
        look.lw * 0.6,
        look,
      );
    }
  }
  _mouth(canvas, t, look, front, corner, mouthInk ?? look.ink);
}

void _mouth(
  Canvas canvas,
  Toon t,
  Look look,
  Offset front,
  Offset corner,
  Color ink,
) {
  final ex = t.expression;
  final fx = front.dx, fy = front.dy, cx = corner.dx, cy = corner.dy;
  final mid = lerp(front, corner, 0.5);
  if (ex == Expression.grin) {
    final shape = smooth([
      Offset(fx, fy - 0.04 * _u),
      Offset(mid.dx, mid.dy - 0.02 * _u),
      Offset(cx, cy - 0.06 * _u),
      Offset(cx + 0.12 * _u, cy + 0.16 * _u),
      Offset(mid.dx, mid.dy + 0.34 * _u),
      Offset(fx - 0.06 * _u, fy + 0.2 * _u),
    ], tension: 0.45);
    part(
      canvas,
      shape,
      const Color(0xFF5A1420),
      look,
      shade: 0,
      lw: look.lw * 0.9,
    );
    clipped(canvas, shape, () {
      fillPath(
        canvas,
        noodle(
          [
            Offset(fx + 0.1 * _u, fy - 0.02 * _u),
            mid,
            Offset(cx - 0.1 * _u, cy - 0.04 * _u),
          ],
          0.18 * _u,
          0.18 * _u,
        ),
        _white,
      );
      fillPath(
        canvas,
        ellipse(
          Offset(mid.dx - 0.05 * _u, mid.dy + 0.3 * _u),
          0.26 * _u,
          0.13 * _u,
        ),
        const Color(0xFFE0596A),
      );
    });
    strokePath(canvas, shape, look.ink, look.lw * 1.8);
    return;
  }
  final sag =
      switch (ex) {
        Expression.smug => 0.07,
        Expression.sly => 0.06,
        Expression.sultry => 0.05,
        _ => 0.09,
      } *
      _u;
  final lips = t.lips;
  if (lips != null) {
    final shape = smooth([
      Offset(fx + 0.06 * _u, fy - 0.08 * _u),
      Offset(fx - 0.12 * _u, fy - 0.1 * _u),
      Offset(fx - 0.26 * _u, fy - 0.02 * _u),
      Offset(fx - 0.14 * _u, fy + 0.02 * _u),
      Offset(fx - 0.26 * _u, fy + 0.08 * _u),
      Offset(fx - 0.1 * _u, fy + 0.16 * _u),
      Offset(fx + 0.06 * _u, fy + 0.1 * _u),
    ], tension: 0.45);
    brush(
      canvas,
      [
        Offset(fx - 0.2 * _u, fy + 0.02 * _u),
        Offset(mid.dx, mid.dy + sag * 0.8),
        Offset(cx, cy - 0.04 * _u),
      ],
      look.lw * 1.4,
      look.lw * 0.8,
      look,
      ink,
    );
    part(canvas, shape, lips, look, shade: 0.15, lw: look.lw * 0.8);
    fillPath(
      canvas,
      ellipse(
        Offset(fx - 0.06 * _u, fy - 0.05 * _u),
        0.06 * _u,
        0.025 * _u,
        -0.2,
      ),
      alpha(_white, 0.6),
    );
  } else {
    brush(
      canvas,
      [front, Offset(mid.dx, mid.dy + sag), Offset(cx, cy - 0.02 * _u)],
      look.lw,
      look.lw * 1.8,
      look,
      ink,
    );
  }
  // The up-turned corner and its dimple.
  brush(
    canvas,
    [
      Offset(cx + 0.04 * _u, cy + 0.02 * _u),
      Offset(cx - 0.04 * _u, cy - 0.1 * _u),
      Offset(cx - 0.02 * _u, cy - 0.2 * _u),
    ],
    look.lw * 1.6,
    look.lw * 0.6,
    look,
    ink,
  );
}

void _cow(Canvas canvas, Toon t, Look look) {
  const horn = Color(0xFFF3E6C4);
  part(
    canvas,
    noodle(
      _h([(0.3, -0.86), (0.56, -1.06), (0.66, -1.36)]),
      0.24 * _u,
      0.07 * _u,
    ),
    darker(horn, 0.15),
    look,
    shade: 0.2,
  );
  final skull = smooth(
    _h([
      (-0.05, -1.02),
      (0.45, -0.92),
      (0.62, -0.5),
      (0.55, -0.05),
      (0.1, 0.3),
      (-0.45, 0.2),
      (-0.66, -0.3),
      (-0.5, -0.85),
    ]),
    tension: 0.55,
  );
  part(canvas, skull, t.fur, look, shade: 0.18);
  clipped(
    canvas,
    skull,
    () => fillPath(
      canvas,
      smooth(
        _h([
          (-0.9, -0.95),
          (-0.25, -1.15),
          (-0.12, -0.72),
          (-0.36, -0.42),
          (-0.9, -0.36),
        ]),
      ),
      t.fur2,
    ),
  );
  strokePath(canvas, skull, look.ink, look.lw * 2);
  final muzzle = smooth(
    _h([
      (0.22, -0.1),
      (0.8, -0.22),
      (1.22, -0.06),
      (1.34, 0.3),
      (1.14, 0.64),
      (0.6, 0.72),
      (0.16, 0.54),
      (0.06, 0.2),
    ]),
    tension: 0.55,
  );
  part(canvas, muzzle, t.face, look, shade: 0.18);
  fillPath(
    canvas,
    ellipse(_o(1.06, 0.1), 0.11 * _u, 0.065 * _u, -0.5),
    darker(t.face, 0.5),
  );
  _highlight(canvas, _o(0.7, -0.08), 0.2 * _u, 0.06 * _u, -0.15);
  // Ear sticking out backwards, then the near horn and the forelock.
  part(
    canvas,
    smooth(
      _h([
        (-0.36, -0.66),
        (-0.82, -0.86),
        (-1.22, -0.74),
        (-0.92, -0.46),
        (-0.42, -0.42),
      ]),
      tension: 0.45,
    ),
    t.fur,
    look,
    shade: 0.15,
  );
  fillPath(
    canvas,
    smooth(
      _h([(-0.5, -0.6), (-0.84, -0.74), (-1.08, -0.7), (-0.86, -0.54)]),
      tension: 0.45,
    ),
    t.face,
  );
  part(
    canvas,
    noodle(
      _h([(-0.3, -0.86), (-0.52, -1.08), (-0.48, -1.38)]),
      0.26 * _u,
      0.08 * _u,
    ),
    horn,
    look,
    shade: 0.2,
  );
  part(
    canvas,
    noodle(
      _h([(0.0, -0.96), (0.22, -1.12), (0.42, -1.06), (0.36, -0.9)]),
      0.2 * _u,
      0.06 * _u,
    ),
    t.fur2,
    look,
    shade: 0.1,
  );
  _features(
    canvas,
    t,
    look,
    near: _o(0.1, -0.5),
    far: _o(0.46, -0.54),
    ew: 0.21 * _u,
    eh: 0.31 * _u,
    skin: t.fur,
    front: _o(1.12, 0.48),
    corner: _o(0.44, 0.46),
  );
}

void _dog(Canvas canvas, Toon t, Look look) {
  final rust = t.fur2, white = t.face;
  final skull = smooth(
    _h([
      (-0.05, -1.0),
      (0.42, -0.9),
      (0.6, -0.5),
      (0.5, -0.1),
      (0.1, 0.3),
      (-0.45, 0.22),
      (-0.66, -0.28),
      (-0.5, -0.84),
    ]),
    tension: 0.55,
  );
  part(canvas, skull, t.fur, look, shade: 0.12, highlight: 0.3);
  clipped(canvas, skull, () {
    fillPath(
      canvas,
      noodle(
        _h([(0.46, -0.2), (0.3, -0.66), (0.06, -1.1)]),
        0.34 * _u,
        0.14 * _u,
      ),
      white,
    );
    fillPath(canvas, ellipse(_o(0.2, 0.06), 0.34 * _u, 0.2 * _u, 0.2), rust);
  });
  strokePath(canvas, skull, look.ink, look.lw * 2);
  final snout = smooth(
    _h([
      (0.3, -0.3),
      (0.8, -0.24),
      (1.3, -0.12),
      (1.46, 0.12),
      (1.32, 0.42),
      (0.9, 0.56),
      (0.4, 0.56),
      (0.12, 0.32),
    ]),
    tension: 0.55,
  );
  part(canvas, snout, white, look, shade: 0.16);
  _highlight(canvas, _o(0.85, -0.14), 0.24 * _u, 0.05 * _u, 0.1);
  line(
    canvas,
    _h([(1.4, 0.12), (1.36, 0.24), (1.32, 0.36)]),
    look,
    look.lw * 0.9,
  );
  part(
    canvas,
    ellipse(_o(1.44, 0.02), 0.2 * _u, 0.15 * _u, 0.15),
    const Color(0xFF1A1418),
    look,
    shade: 0,
    highlight: 0.6,
  );
  _highlight(canvas, _o(1.4, -0.05), 0.07 * _u, 0.035 * _u, -0.3);
  // Long floppy ear over the back of the head.
  final ear = smooth(
    _h([
      (-0.12, -0.86),
      (-0.5, -0.86),
      (-0.76, -0.36),
      (-0.76, 0.3),
      (-0.56, 0.5),
      (-0.34, 0.3),
      (-0.26, -0.3),
      (-0.04, -0.72),
    ]),
  );
  part(canvas, ear, darker(t.fur, 0.35), look, shade: 0.1, highlight: 0.3);
  strokePath(
    canvas,
    smooth(_h([(-0.24, -0.7), (-0.44, -0.3), (-0.46, 0.2)]), closed: false),
    alpha(lighter(t.fur, 0.35), 0.6),
    look.lw * 0.8,
  );
  for (final (c, r) in [
    (_o(0.12, -0.86), 0.08 * _u),
    (_o(0.44, -0.88), 0.065 * _u),
  ]) {
    fillPath(canvas, ellipse(c, r * 1.3, r, -0.2), rust);
  }
  _features(
    canvas,
    t,
    look,
    near: _o(0.12, -0.48),
    far: _o(0.46, -0.5),
    ew: 0.21 * _u,
    eh: 0.3 * _u,
    skin: lighter(t.fur, 0.1),
    front: _o(1.3, 0.4),
    corner: _o(0.5, 0.44),
    brows: false,
  );
}

void _monkey(Canvas canvas, Toon t, Look look) {
  for (final (x, a) in [(-0.34, -0.9), (-0.16, -0.5), (0.02, -0.15)]) {
    final base = _o(x, -0.9);
    final tip = Offset(
      x * _u + sin(a) * 0.38 * _u,
      -1.3 * _u + a.abs() * 0.12 * _u,
    );
    part(
      canvas,
      noodle([base, lerp(base, tip, 0.6), tip], 0.22 * _u, 0.04 * _u),
      t.fur,
      look,
      shade: 0.1,
    );
  }
  final skull = smooth(
    _h([
      (0.0, -1.0),
      (0.5, -0.9),
      (0.68, -0.45),
      (0.6, 0.05),
      (0.2, 0.42),
      (-0.4, 0.36),
      (-0.68, -0.2),
      (-0.52, -0.82),
    ]),
    tension: 0.55,
  );
  part(canvas, skull, t.fur, look, shade: 0.18);
  final mask = smooth(
    _h([
      (0.04, -0.86),
      (0.44, -0.9),
      (0.74, -0.56),
      (0.64, -0.2),
      (1.0, -0.08),
      (1.14, 0.28),
      (0.9, 0.62),
      (0.36, 0.64),
      (0.02, 0.32),
      (-0.06, -0.2),
      (-0.14, -0.6),
    ]),
  );
  part(canvas, mask, t.face, look, shade: 0.14);
  _highlight(canvas, _o(0.84, -0.02), 0.14 * _u, 0.05 * _u, 0.3);
  fillPath(
    canvas,
    ellipse(_o(1.02, 0.1), 0.06 * _u, 0.04 * _u, -0.4),
    darker(t.face, 0.6),
  );
  part(canvas, circle(_o(-0.3, -0.28), 0.3 * _u), t.fur, look, shade: 0.15);
  part(
    canvas,
    circle(_o(-0.28, -0.28), 0.17 * _u),
    t.face,
    look,
    shade: 0.1,
    lw: look.lw * 0.6,
  );
  _features(
    canvas,
    t,
    look,
    near: _o(0.2, -0.46),
    far: _o(0.52, -0.48),
    ew: 0.2 * _u,
    eh: 0.29 * _u,
    skin: t.face,
    front: _o(1.04, 0.42),
    corner: _o(0.42, 0.38),
  );
}

void _zebra(Canvas canvas, Toon t, Look look) {
  final stripe = t.fur2, dark = t.face;
  for (final (x, lean, color) in [
    (0.1, 0.05, darker(t.fur, 0.12)),
    (-0.18, -0.12, t.fur),
  ]) {
    part(
      canvas,
      smooth(
        _h([
          (x - 0.16, -0.8),
          (x + lean - 0.1, -1.5),
          (x + lean + 0.02, -1.64),
          (x + 0.18, -0.84),
        ]),
        tension: 0.4,
      ),
      color,
      look,
      shade: 0.15,
    );
    fillPath(
      canvas,
      smooth(
        _h([(x - 0.06, -0.9), (x + lean - 0.02, -1.46), (x + 0.08, -0.92)]),
        tension: 0.4,
      ),
      alpha(stripe, 0.85),
    );
  }
  // Mane from between the ears down the nape.
  final center = _o(-0.05, -0.38);
  const n = 13;
  double maneAngle(double k) => radians(-62 - k * 132 / (n - 1));
  final outer = <Offset>[], inner = <Offset>[];
  for (var k = 0; k < n; k++) {
    final a = maneAngle(k.toDouble());
    outer.add(at(center, a, (0.98 + (k.isOdd ? 0.1 : 0)) * _u));
    inner.add(at(center, a, 0.5 * _u));
  }
  final crest = smooth([...outer, ...inner.reversed], tension: 0.35);
  part(canvas, crest, t.fur, look, shade: 0.1);
  clipped(canvas, crest, () {
    for (var k = 0; k < n; k += 2) {
      fillPath(
        canvas,
        polygon([
          center,
          at(center, maneAngle(k.toDouble()), 2 * _u),
          at(center, maneAngle(k + 0.8), 2 * _u),
        ]),
        stripe,
      );
    }
  });
  strokePath(canvas, crest, look.ink, look.lw * 2);
  final skull = smooth(
    _h([
      (-0.1, -1.0),
      (0.4, -0.88),
      (0.58, -0.45),
      (0.5, -0.05),
      (0.1, 0.25),
      (-0.4, 0.2),
      (-0.6, -0.3),
      (-0.5, -0.82),
    ]),
    tension: 0.55,
  );
  final muzzle = smooth(
    _h([
      (0.2, -0.66),
      (0.8, -0.34),
      (1.24, 0.02),
      (1.44, 0.38),
      (1.32, 0.72),
      (0.96, 0.82),
      (0.5, 0.62),
      (0.06, 0.32),
    ]),
    tension: 0.55,
  );
  final head = union([skull, muzzle]);
  part(canvas, head, t.fur, look, shade: 0.16);
  final axis = atan2(0.9, 1.0) + pi / 2;
  final across = Offset(cos(axis), sin(axis));
  clipped(canvas, head, () {
    for (var k = 0; k < 5; k++) {
      final c = lerp(_o(0.3, -0.5), _o(1.0, 0.12), k / 4);
      fillPath(
        canvas,
        noodle(
          [c - across * 0.6 * _u, c + _o(0.03, 0.03), c + across * 0.6 * _u],
          0.08 * _u,
          0.08 * _u,
        ),
        stripe,
      );
    }
    for (var k = 0; k < 4; k++) {
      final y = -0.9 + k * 0.24;
      fillPath(
        canvas,
        noodle(
          _h([(-0.7, y - 0.1), (-0.3, y + 0.04), (0.0, y + 0.16)]),
          0.1 * _u,
          0.03 * _u,
        ),
        stripe,
      );
    }
    fillPath(canvas, ellipse(_o(1.26, 0.46), 0.36 * _u, 0.42 * _u, 0.5), dark);
  });
  strokePath(canvas, head, look.ink, look.lw * 2);
  fillPath(
    canvas,
    ellipse(_o(1.28, 0.22), 0.1 * _u, 0.06 * _u, -0.6),
    lighter(dark, 0.35),
  );
  _highlight(canvas, _o(0.9, -0.22), 0.2 * _u, 0.05 * _u, 0.6);
  _features(
    canvas,
    t,
    look,
    near: _o(0.06, -0.52),
    far: _o(0.38, -0.56),
    ew: 0.2 * _u,
    eh: 0.3 * _u,
    skin: t.fur,
    front: _o(1.36, 0.6),
    corner: _o(0.98, 0.64),
    mouthInk: lighter(dark, 0.55),
  );
}
