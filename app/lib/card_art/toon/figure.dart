import 'dart:math';
import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

import '../toolkit/geometry.dart';
import '../toolkit/ink.dart';
import '../toolkit/suit_shapes.dart';
import 'heads.dart';
import 'parts.dart';
import 'toon.dart';

const _u = headUnit;

/// Paints a slender 1930s cartoon figure posed in a 400×600 box.
void paintToon(Canvas canvas, Toon t, Look look) {
  final p = t.pose;
  for (final MapEntry(key: side, value: arm) in p.arms.entries) {
    if (arm.behind) _arm(canvas, t, look, side);
  }
  _outfitBack(canvas, t, look);
  _tail(canvas, t, look);
  for (final side in p.legOrder) {
    _leg(canvas, t, look, side);
  }
  _neck(canvas, t, look);
  _outfit(canvas, t, look);
  if (t.animal == Animal.cow && t.outfit == Outfit.jack) {
    _cowbell(canvas, t, look);
  }
  paintHead(canvas, t, look);
  _hat(canvas, t, look);
  for (final side in Side.values) {
    if (!p.arms[side]!.behind) _arm(canvas, t, look, side);
  }
}

// ------------------------------------------------------------------ hats

void _hat(Canvas canvas, Toon t, Look look) {
  final p = t.pose;
  canvas.save();
  canvas.translate(p.head.dx, p.head.dy);
  canvas.rotate(radians(p.tilt + p.hatTilt));
  final top =
      switch (t.animal) {
        Animal.cow => -0.98,
        Animal.zebra => -0.97,
        _ => -0.96,
      } *
      _u;
  final gold = t.costume.trim, accent = t.costume.main;
  final ox = p.hatX * _u;
  switch (t.hat) {
    case Hat.crown:
      final w = 0.5 * _u, h = 0.62 * _u;
      final peaks = [
        Offset(ox - w * 1.08, top - h),
        Offset(ox, top - h * 1.15),
        Offset(ox + w * 1.08, top - h),
      ];
      part(
        canvas,
        polygon([
          Offset(ox - w, top + 0.06 * _u),
          peaks[0],
          Offset(ox - w * 0.5, top - h * 0.5),
          peaks[1],
          Offset(ox + w * 0.5, top - h * 0.5),
          peaks[2],
          Offset(ox + w, top + 0.06 * _u),
        ]),
        gold,
        look,
        shade: 0.22,
        highlight: 0.4,
      );
      part(
        canvas,
        rectangle(ox - w * 1.02, top - 0.12 * _u, w * 2.04, 0.2 * _u),
        gold,
        look,
        shade: 0.2,
      );
      for (final peak in peaks) {
        part(
          canvas,
          circle(peak, 0.08 * _u),
          paperWhite,
          look,
          shade: 0,
          lw: look.lw * 0.6,
        );
      }
      part(
        canvas,
        suitShape(t.suit, Offset(ox, top - 0.02 * _u), 0.2 * _u),
        t.costume.suit,
        look,
        shade: 0,
        lw: look.lw * 0.5,
      );
    case Hat.tiara:
      final w = 0.42 * _u;
      part(
        canvas,
        smooth([
          Offset(ox - w, top + 0.08 * _u),
          Offset(ox - w * 0.6, top - 0.1 * _u),
          Offset(ox - w * 0.25, top - 0.14 * _u),
          Offset(ox, top - 0.42 * _u),
          Offset(ox + w * 0.25, top - 0.14 * _u),
          Offset(ox + w * 0.6, top - 0.1 * _u),
          Offset(ox + w, top + 0.08 * _u),
        ], tension: 0.25),
        gold,
        look,
        shade: 0.2,
        highlight: 0.4,
      );
      part(
        canvas,
        suitShape(t.suit, Offset(ox, top - 0.12 * _u), 0.24 * _u),
        t.costume.suit,
        look,
        shade: 0,
        lw: look.lw * 0.5,
      );
    case Hat.pillbox:
      part(
        canvas,
        smooth([
          Offset(ox - 0.42 * _u, top + 0.04 * _u),
          Offset(ox - 0.38 * _u, top - 0.42 * _u),
          Offset(ox + 0.38 * _u, top - 0.42 * _u),
          Offset(ox + 0.42 * _u, top + 0.04 * _u),
        ], tension: 0.15),
        accent,
        look,
        shade: 0.22,
        highlight: 0.3,
      );
      part(
        canvas,
        rectangle(ox - 0.43 * _u, top - 0.06 * _u, 0.86 * _u, 0.12 * _u),
        gold,
        look,
        shade: 0,
      );
      part(
        canvas,
        suitShape(t.suit, Offset(ox, top - 0.24 * _u), 0.22 * _u),
        gold,
        look,
        shade: 0,
        lw: look.lw * 0.5,
      );
    case Hat.feather:
      part(
        canvas,
        noodle(
          [
            Offset(ox + 0.3 * _u, top - 0.2 * _u),
            Offset(ox + 0.8 * _u, top - 0.5 * _u),
            Offset(ox + 1.15 * _u, top - 0.45 * _u),
          ],
          0.3 * _u,
          0.04 * _u,
        ),
        gold,
        look,
        shade: 0.2,
      );
      line(
        canvas,
        [
          Offset(ox + 0.32 * _u, top - 0.2 * _u),
          Offset(ox + 0.8 * _u, top - 0.46 * _u),
          Offset(ox + 1.1 * _u, top - 0.44 * _u),
        ],
        look,
        look.lw * 0.6,
      );
      part(
        canvas,
        smooth([
          Offset(ox - 0.44 * _u, top),
          Offset(ox - 0.36 * _u, top - 0.42 * _u),
          Offset(ox + 0.3 * _u, top - 0.5 * _u),
          Offset(ox + 0.44 * _u, top),
        ], tension: 0.35),
        accent,
        look,
        shade: 0.2,
      );
      part(
        canvas,
        ellipse(Offset(ox, top + 0.02 * _u), 0.62 * _u, 0.13 * _u),
        accent,
        look,
        shade: 0.2,
      );
      part(
        canvas,
        rectangle(ox - 0.42 * _u, top - 0.16 * _u, 0.86 * _u, 0.12 * _u),
        gold,
        look,
        shade: 0,
      );
  }
  canvas.restore();
}

// ------------------------------------------------------------------ body

Path _torso(Pose p) {
  final c = p.chest, w = p.waist, h = p.hip;
  final (cw, ww, hw) = p.widths;
  return smooth([
    Offset(c.dx - cw * 0.38, c.dy - 8),
    Offset(c.dx - cw * 0.5, c.dy + 10),
    Offset(w.dx - ww * 0.5, w.dy),
    Offset(h.dx - hw * 0.5, h.dy),
    Offset(h.dx - hw * 0.2, h.dy + hw * 0.32),
    Offset(h.dx + hw * 0.2, h.dy + hw * 0.32),
    Offset(h.dx + hw * 0.5, h.dy),
    Offset(w.dx + ww * 0.5, w.dy),
    Offset(c.dx + cw * 0.5, c.dy + 10),
    Offset(c.dx + cw * 0.38, c.dy - 8),
    Offset(c.dx, c.dy - 12),
  ]);
}

Offset shoulder(Pose p, Side side) {
  final tilt = radians(p.shoulderTilt);
  final d = Offset(cos(tilt), sin(tilt)) * (p.widths.$1 * 0.42);
  final base = p.chest + const Offset(0, 4);
  return side == Side.l ? base - d : base + d;
}

Offset _hipJoint(Pose p, Side side) =>
    p.hip + Offset((side == Side.l ? -1 : 1) * p.widths.$3 * 0.24, 8);

/// Zebra stripes across a bare limb.
void _furPattern(
  Canvas canvas,
  Toon t,
  Path shape,
  List<Offset> points,
  double width,
  Look look,
) {
  if (t.animal != Animal.zebra) return;
  clipped(canvas, shape, () {
    final path = catmull(points, 10);
    final n = path.length - 1;
    for (var i = 3; i < n - 1; i += 4) {
      final ang = angleOf(path[i - 1], path[i + 1]) + pi / 2;
      final c = path[i];
      fillPath(
        canvas,
        noodle(
          [
            at(c, ang, -width),
            at(c, ang + 0.25, width * 0.1),
            at(c, ang + 0.1, width),
          ],
          4.5,
          2.5,
        ),
        t.fur2,
      );
    }
  });
  strokePath(canvas, shape, look.ink, look.lw * 2);
}

void _leg(Canvas canvas, Toon t, Look look, Side side) {
  final leg = t.pose.legs[side]!;
  final points = [_hipJoint(t.pose, side), ...leg.path];
  final shape = noodle(points, 19, 10);
  part(canvas, shape, t.legColor ?? t.fur, look, shade: 0.15);
  if (t.legColor == null) _furPattern(canvas, t, shape, points, 10, look);
  shoe(
    canvas,
    points.last,
    leg.facing ?? (side == Side.r ? 1 : -1),
    t.shoeKind == ShoeKind.heel ? 40 : 38,
    t.shoeKind,
    t.shoeColor,
    look,
    tilt: leg.tilt,
    accent: t.shoeAccent,
  );
}

void _arm(Canvas canvas, Toon t, Look look, Side side) {
  final arm = t.pose.arms[side]!;
  final points = [shoulder(t.pose, side), ...arm.path];
  final color = arm.sleeve == Sleeve.main ? t.costume.main : t.fur;
  final shape = noodle(points, 15, 10);
  part(canvas, shape, color, look, shade: 0.15);
  if (arm.sleeve != Sleeve.main) _furPattern(canvas, t, shape, points, 8, look);
  final wrist = points.last;
  final angle = arm.angle == null
      ? angleOf(points[points.length - 2], wrist)
      : radians(arm.angle!);
  if (arm.prop != null && arm.propUnder) {
    _prop(canvas, t, look, wrist, angle, arm);
  }
  hand(
    canvas,
    wrist,
    angle,
    34,
    arm.hand,
    look,
    thumb: arm.thumb ?? (side == Side.r ? 1 : -1),
  );
  if (arm.prop != null && !arm.propUnder) {
    _prop(canvas, t, look, wrist, angle, arm);
  }
}

void _prop(
  Canvas canvas,
  Toon t,
  Look look,
  Offset wrist,
  double angle,
  Arm arm,
) {
  final gold = t.costume.trim, accent = t.costume.main;
  final grip = at(wrist, angle, 15);
  switch (arm.prop!) {
    case Prop.scepter:
      final top = arm.top ?? grip - const Offset(0, 150);
      final bottom = grip * 1.35 - top * 0.35;
      part(canvas, noodle([bottom, top], 9, 9), gold, look, shade: 0.2);
      part(canvas, circle(top, 13), gold, look, shade: 0.2, highlight: 0.4);
      final a = angleOf(grip, top);
      final head = at(top, a, 26);
      part(
        canvas,
        transformed(
          suitShape(t.suit, head, 40),
          angle: a + pi / 2,
          about: head,
        ),
        t.costume.suit,
        look,
        shade: 0.2,
        highlight: 0.5,
      );
    case Prop.fan:
      final c = at(wrist, angle, 20);
      const r = 64.0, ribs = 9;
      final spread = radians(arm.spread ?? 150);
      final base = radians(arm.fanDir ?? -90);
      double rib(int k) => base - spread / 2 + spread * k / ribs;
      part(
        canvas,
        polygon([
          c,
          for (var k = 0; k <= ribs; k++)
            at(c, rib(k), r * (k.isEven ? 1 : 0.94)),
        ]),
        accent,
        look,
        shade: 0.15,
      );
      for (var k = 0; k <= ribs; k++) {
        line(
          canvas,
          [at(c, rib(k), 10), at(c, rib(k), r * 0.92)],
          look,
          look.lw * 0.5,
          alpha(darker(accent, 0.5), 0.8),
        );
      }
      part(
        canvas,
        suitShape(t.suit, at(c, base, r * 0.6), 30),
        t.costume.suit,
        look,
        shade: 0,
        lw: look.lw * 0.5,
      );
      part(canvas, circle(c, 6), gold, look, shade: 0);
    case Prop.halberd:
      final top = arm.top ?? grip - const Offset(0, 200);
      final a = angleOf(grip, top);
      final bottom = at(grip, a + pi, arm.below ?? 120);
      part(
        canvas,
        noodle([bottom, top], 7, 7),
        const Color(0xFF8A5A2B),
        look,
        shade: 0.2,
      );
      final blade = at(top, a, 18);
      part(
        canvas,
        transformed(
          suitShape(Suit.spades, Offset.zero, 40),
          dx: blade.dx,
          dy: blade.dy,
          angle: a + pi / 2,
        ),
        const Color(0xFFD8DDE2),
        look,
        shade: 0.25,
        highlight: 0.5,
      );
      final base = at(top, a + pi, 20);
      final side = arm.flagSide ?? 1;
      final normal = Offset(cos(a + pi / 2), sin(a + pi / 2)) * side.toDouble();
      final p1 = at(base, a + pi, 56);
      final tip = base + normal * 70 + Offset(cos(a + pi), sin(a + pi)) * 34;
      part(
        canvas,
        smooth([
          base,
          lerp(base, tip, 0.5) - const Offset(0, 6),
          tip,
          lerp(p1, tip, 0.5) + const Offset(0, 4),
          p1,
        ], tension: 0.3),
        accent,
        look,
        shade: 0.15,
      );
      part(
        canvas,
        suitShape(t.suit, lerp(lerp(base, p1, 0.5), tip, 0.35), 24),
        gold,
        look,
        shade: 0,
        lw: look.lw * 0.5,
      );
    case Prop.rose:
      final end = at(grip, angle + (arm.stem ?? -1.2), 60);
      line(canvas, [grip, end], look, 4, const Color(0xFF2F7D3A));
      part(canvas, circle(end, 13), const Color(0xFFD42A3A), look, shade: 0.2);
      line(
        canvas,
        [
          end - const Offset(6, 0),
          end - const Offset(0, 5),
          end + const Offset(5, 2),
        ],
        look,
        2,
      );
    case Prop.mirror:
      final c = at(grip, angle + (arm.stem ?? -1.4), 52);
      line(canvas, [grip, c], look, 8, gold);
      part(canvas, ellipse(c, 24, 30, angle), gold, look, shade: 0.2);
      part(
        canvas,
        ellipse(c, 17, 23, angle),
        const Color(0xFFBFE3EC),
        look,
        shade: 0,
        lw: look.lw * 0.6,
      );
  }
}

void _tail(Canvas canvas, Toon t, Look look) {
  final tail = t.pose.tail;
  if (tail == null) return;
  final points = [t.pose.hip + const Offset(0, 4), ...tail];
  final end = points.last;
  final a = angleOf(points[points.length - 2], end);
  switch (t.animal) {
    case Animal.monkey:
      part(canvas, noodle(points, 11, 6), t.fur, look, shade: 0.15);
    case Animal.dog:
      part(
        canvas,
        noodle([...points, at(end, a, 14)], 12, 3),
        t.fur,
        look,
        shade: 0.12,
        highlight: 0.3,
      );
    case Animal.cow || Animal.zebra:
      part(canvas, noodle(points, 8, 5), t.fur, look, shade: 0.1);
      final tuft = smooth([
        at(end, a + 1.4, 6),
        at(end, a + 0.5, 18),
        at(end, a, 30),
        at(end, a - 0.5, 18),
        at(end, a - 1.4, 6),
      ], tension: 0.4);
      part(canvas, tuft, t.fur2, look, shade: 0.1);
  }
}

// ------------------------------------------------------------------ outfits

void _outfitBack(Canvas canvas, Toon t, Look look) {
  if (t.outfit != Outfit.king) return;
  final p = t.pose;
  final c = p.chest, cw = p.widths.$1, hem = p.capeHem, sway = p.capeSway;
  final cape = smooth([
    Offset(c.dx - cw * 0.5, c.dy - 2),
    Offset(c.dx - cw * 0.9 + sway, c.dy + 80),
    Offset(c.dx - cw * 1.2 + sway * 1.5, hem),
    Offset(c.dx + sway * 1.6, hem + 12),
    Offset(c.dx + cw * 1.2 + sway * 1.5, hem - 6),
    Offset(c.dx + cw * 0.9 + sway, c.dy + 80),
    Offset(c.dx + cw * 0.5, c.dy - 2),
  ], tension: 0.45);
  part(canvas, cape, t.costume.main, look, shade: 0.28);
  clipped(canvas, cape, () {
    fillPath(canvas, rectangle(0, hem - 8, 400, 40), paperWhite);
    for (var k = 0; k < 10; k++) {
      fillPath(
        canvas,
        ellipse(
          Offset(c.dx - cw * 1.3 + sway * 1.5 + k * cw * 0.28, hem + 2),
          2.5,
          5,
        ),
        inkBlack,
      );
    }
  });
  strokePath(canvas, cape, look.ink, look.lw * 2);
}

void _outfit(Canvas canvas, Toon t, Look look) {
  final p = t.pose;
  final (cw, ww, hw) = p.widths;
  final c = p.chest, w = p.waist, h = p.hip;
  final main = t.costume.main, trim = t.costume.trim;
  final torso = _torso(p);
  switch (t.outfit) {
    case Outfit.king:
      part(canvas, torso, main, look, shade: 0.22);
      clipped(canvas, torso, () {
        fillPath(
          canvas,
          noodle(
            [
              Offset(c.dx - cw * 0.5, c.dy - 4),
              w,
              Offset(h.dx + hw * 0.5, h.dy + 10),
            ],
            12,
            14,
            caps: false,
          ),
          trim,
        );
        fillPath(
          canvas,
          rectangle(w.dx - ww, w.dy + 6, ww * 2, 10),
          darker(main, 0.5),
        );
      });
      strokePath(canvas, torso, look.ink, look.lw * 2);
      for (var k = 0; k < 3; k++) {
        final y = c.dy + 22 + k * 18;
        final x = lerp(c, w, (y - c.dy) / max(w.dy - c.dy, 1)).dx;
        part(
          canvas,
          circle(Offset(x + 8, y), 3.2),
          trim,
          look,
          shade: 0,
          lw: look.lw * 0.5,
        );
      }
      part(
        canvas,
        smooth([
          Offset(c.dx - cw * 0.62, c.dy + 2),
          Offset(c.dx - cw * 0.3, c.dy - 14),
          Offset(c.dx + cw * 0.3, c.dy - 14),
          Offset(c.dx + cw * 0.62, c.dy + 2),
          Offset(c.dx + cw * 0.3, c.dy + 14),
          Offset(c.dx, c.dy + 6),
          Offset(c.dx - cw * 0.3, c.dy + 14),
        ], tension: 0.45),
        paperWhite,
        look,
        shade: 0.12,
      );
      for (final (x, y) in [(-0.38, 0.0), (0.0, -0.02), (0.36, 0.02)]) {
        fillPath(
          canvas,
          ellipse(Offset(c.dx + cw * x, c.dy + 2 + y * 100), 2.4, 4.5),
          inkBlack,
        );
      }
    case Outfit.queen:
      _bodice(canvas, t, look, torso);
      _skirt(canvas, t, look);
    case Outfit.jack:
      part(canvas, torso, main, look, shade: 0.22);
      clipped(canvas, torso, () {
        fillPath(canvas, rectangle(0, h.dy - 12, 400, 60), darker(main, 0.45));
        fillPath(canvas, rectangle(c.dx - 4, c.dy - 20, 8, 200), trim);
      });
      strokePath(canvas, torso, look.ink, look.lw * 2);
      for (var k = 0; k < 4; k++) {
        final y = c.dy + 16 + k * 18;
        final x = lerp(c, w, min((y - c.dy) / max(w.dy - c.dy, 1), 1)).dx;
        part(
          canvas,
          circle(Offset(x, y), 3.4),
          trim,
          look,
          shade: 0,
          lw: look.lw * 0.5,
        );
      }
      part(
        canvas,
        smooth([
          Offset(c.dx - cw * 0.34, c.dy - 10),
          Offset(c.dx, c.dy + 10),
          Offset(c.dx + cw * 0.34, c.dy - 10),
          Offset(c.dx, c.dy - 2),
        ], tension: 0.3),
        t.costume.light,
        look,
        shade: 0.1,
      );
      part(
        canvas,
        union([
          polygon([c, c + const Offset(-16, -9), c + const Offset(-16, 9)]),
          polygon([c, c + const Offset(16, -9), c + const Offset(16, 9)]),
        ]),
        trim,
        look,
        shade: 0.15,
      );
  }
}

/// The bust under a sweetheart neckline.
void _bodice(Canvas canvas, Toon t, Look look, Path torso) {
  final c = t.pose.chest, cw = t.pose.widths.$1;
  part(canvas, torso, t.costume.main, look, shade: 0.2);
  final r = cw * 0.31, by = c.dy + 14;
  final busts = [
    for (final side in [-1, 1])
      ellipse(Offset(c.dx + side * cw * 0.24, by), r, r * 0.9, side * 0.25),
  ];
  for (final bust in busts) {
    part(canvas, bust, t.costume.main, look, shade: 0.2, highlight: 0.35);
  }
  final neckline = [
    Offset(c.dx - cw * 0.22, by - r * 0.55),
    Offset(c.dx, by - r * 0.05),
    Offset(c.dx + cw * 0.22, by - r * 0.55),
  ];
  final skin = smooth([
    Offset(c.dx - cw * 0.5, c.dy - 40),
    Offset(c.dx + cw * 0.5, c.dy - 40),
    Offset(c.dx + cw * 0.5, by - r * 0.35),
    ...neckline.reversed,
    Offset(c.dx - cw * 0.5, by - r * 0.35),
  ], tension: 0.3);
  for (final region in [torso, ...busts]) {
    clipped(canvas, region, () => fillPath(canvas, skin, t.fur));
  }
  strokePath(
    canvas,
    smooth(
      [
        Offset(c.dx - cw * 0.48, by - r * 0.3),
        ...neckline,
        Offset(c.dx + cw * 0.48, by - r * 0.3),
      ],
      closed: false,
      tension: 0.4,
    ),
    look.ink,
    look.lw * 1.6,
  );
  line(
    canvas,
    [Offset(c.dx, by - r * 0.15), Offset(c.dx + 1, by + r * 0.15)],
    look,
    look.lw * 0.8,
  );
  for (var k = 0; k < 9; k++) {
    final a = pi * (0.15 + 0.7 * k / 8);
    part(
      canvas,
      circle(Offset(c.dx + cos(a) * 14, c.dy - 14 + sin(a) * 9), 3.2),
      paperWhite,
      look,
      shade: 0,
      lw: look.lw * 0.4,
    );
  }
}

void _skirt(Canvas canvas, Toon t, Look look) {
  final p = t.pose;
  final sk = p.skirt!;
  final (_, ww, hw) = p.widths;
  final w = p.waist, h = p.hip;
  final main = t.costume.main;
  final hem = sk.hem, width = sk.width, sway = sk.sway;
  final knee = lerp(w, Offset(w.dx + sway, hem), 0.55);
  final skirt = smooth([
    Offset(w.dx - ww * 0.55, w.dy),
    Offset(h.dx - hw * 0.62, h.dy + 4),
    Offset(knee.dx - hw * 0.45, knee.dy),
    Offset(w.dx + sway - width * 0.5 * sk.flare, hem - 6),
    Offset(w.dx + sway - width * 0.2, hem + 6),
    Offset(w.dx + sway + width * 0.2, hem + 8),
    Offset(w.dx + sway + width * 0.5 * sk.flare, hem - 4),
    Offset(knee.dx + hw * 0.45, knee.dy),
    Offset(h.dx + hw * 0.62, h.dy + 4),
    Offset(w.dx + ww * 0.55, w.dy),
  ]);
  part(canvas, skirt, main, look, shade: 0.25);
  clipped(canvas, skirt, () {
    for (var k = 0; k < sk.folds; k++) {
      final fx = w.dx + sway * 0.5 + (k - 1) * width * 0.22;
      line(
        canvas,
        [
          Offset(w.dx + (k - 1) * 8, h.dy + 30),
          Offset(fx, hem - 40),
          Offset(fx + sway * 0.1, hem + 4),
        ],
        look,
        look.lw * 0.7,
        alpha(darker(main, 0.5), 0.8),
      );
    }
    fillPath(
      canvas,
      noodle(
        [
          Offset(w.dx + sway - width * 0.7, hem - 14),
          Offset(w.dx + sway, hem - 2),
          Offset(w.dx + sway + width * 0.7, hem - 14),
        ],
        9,
        9,
        caps: false,
      ),
      t.costume.trim,
    );
  });
  strokePath(canvas, skirt, look.ink, look.lw * 2);
  part(
    canvas,
    rectangle(w.dx - ww * 0.55, w.dy - 5, ww * 1.1, 10),
    t.costume.trim,
    look,
    shade: 0,
  );
  part(
    canvas,
    suitShape(t.suit, w, 18),
    t.costume.suit,
    look,
    shade: 0,
    lw: look.lw * 0.5,
  );
}

void _neck(Canvas canvas, Toon t, Look look) {
  final points = [t.pose.head + const Offset(0, 30), t.pose.chest];
  final shape = noodle(points, 18, 20);
  part(canvas, shape, t.fur, look, shade: 0.12);
  _furPattern(canvas, t, shape, points, 10, look);
}

void _cowbell(Canvas canvas, Toon t, Look look) {
  final c = t.pose.chest;
  final x = c.dx, y = c.dy + 18;
  line(
    canvas,
    [Offset(x - 12, c.dy - 6), Offset(x, y - 12), Offset(x + 12, c.dy - 6)],
    look,
    3,
    darker(t.costume.main, 0.5),
  );
  part(
    canvas,
    smooth([
      Offset(x - 7, y - 10),
      Offset(x + 7, y - 10),
      Offset(x + 12, y + 10),
      Offset(x, y + 13),
      Offset(x - 12, y + 10),
    ], tension: 0.35),
    const Color(0xFFF2C14A),
    look,
    shade: 0.25,
    highlight: 0.5,
    lw: look.lw * 0.7,
  );
  fillPath(canvas, circle(Offset(x, y + 12), 3), look.ink);
}
