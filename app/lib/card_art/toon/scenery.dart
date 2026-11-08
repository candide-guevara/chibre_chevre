import 'dart:math';
import 'dart:ui';

import '../toolkit/geometry.dart';
import '../toolkit/ink.dart';
import 'toon.dart';

/// The colours a design gives to the landscapes behind the figures.
class ScenePalette {
  const ScenePalette({
    required this.far,
    required this.snow,
    required this.mid,
    required this.near,
    required this.detail,
    required this.flower,
    required this.sun,
  });

  final Color far, snow, mid, near, detail, flower, sun;
}

/// Paints the home landscape of [animal] inside [box]: Alps for the cows, an
/// old town for the dogs, jungle for the monkeys, savanna for the zebras.
void paintScene(
  Canvas canvas,
  Animal animal,
  Rect box,
  ScenePalette pal,
  int seed,
) {
  final rnd = Random(seed);
  switch (animal) {
    case Animal.cow:
      _meadow(canvas, box, pal, rnd);
    case Animal.dog:
      _village(canvas, box, pal, rnd);
    case Animal.monkey:
      _jungle(canvas, box, pal, rnd);
    case Animal.zebra:
      _savanna(canvas, box, pal, rnd);
  }
}

double _between(Random rnd, double a, double b) =>
    a + rnd.nextDouble() * (b - a);

void _hill(
  Canvas canvas,
  Rect box,
  double left,
  double middle,
  double right,
  Color color,
) {
  fillPath(
    canvas,
    smooth([
      Offset(box.left - 40, left),
      Offset(box.left + 100, middle),
      Offset(box.right + 40, right),
      Offset(box.right + 40, 600),
      Offset(box.left - 40, 600),
    ]),
    color,
  );
}

void _meadow(Canvas canvas, Rect box, ScenePalette pal, Random rnd) {
  final x0 = box.left, x1 = box.right;
  fillPath(
    canvas,
    polygon([
      Offset(x0 - 20, 360),
      Offset(x0 + 30, 270),
      Offset(x0 + 70, 320),
      Offset(x0 + 120, 230),
      Offset(x0 + 170, 300),
      Offset(x0 + 210, 250),
      Offset(x1 + 20, 330),
      Offset(x1 + 20, 420),
      Offset(x0 - 20, 420),
    ]),
    pal.far,
  );
  for (final (peak, w) in [
    (Offset(x0 + 120, 230), 26.0),
    (Offset(x0 + 210, 250), 20.0),
    (Offset(x0 + 30, 270), 18.0),
  ]) {
    final px = peak.dx, py = peak.dy;
    fillPath(
      canvas,
      polygon([
        Offset(px, py),
        Offset(px + w, py + w * 1.2),
        Offset(px + w * 0.4, py + w * 0.9),
        Offset(px, py + w * 1.3),
        Offset(px - w * 0.4, py + w * 0.9),
        Offset(px - w, py + w * 1.2),
      ]),
      pal.snow,
    );
  }
  fillPath(
    canvas,
    smooth([
      Offset(x0 - 40, 400),
      Offset(x0 + 60, 360),
      Offset(x0 + 160, 384),
      Offset(x1 + 40, 350),
      Offset(x1 + 40, 600),
      Offset(x0 - 40, 600),
    ]),
    pal.mid,
  );
  _hill(canvas, box, 440, 420, 432, pal.near);
  for (var i = 0; i < 7; i++) {
    final x = x0 + 8 + i * (x1 - x0 - 16) / 6;
    final y = 452 + _between(rnd, -4, 4);
    strokePath(
      canvas,
      polygon([Offset(x, y), Offset(x, y - 30)], closed: false),
      pal.detail,
      3.5,
    );
  }
  strokePath(
    canvas,
    polygon([Offset(x0, 436), Offset(x1, 430)], closed: false),
    pal.detail,
    3,
  );
  strokePath(
    canvas,
    polygon([Offset(x0, 446), Offset(x1, 440)], closed: false),
    pal.detail,
    3,
  );
  for (var i = 0; i < 14; i++) {
    fillPath(
      canvas,
      circle(Offset(_between(rnd, x0, x1), _between(rnd, 480, 560)), 3),
      pal.flower,
    );
  }
}

void _village(Canvas canvas, Rect box, ScenePalette pal, Random rnd) {
  final x0 = box.left, x1 = box.right;
  final tx = x1 - 52;
  fillPath(
    canvas,
    polygon([
      Offset(tx - 18, 420),
      Offset(tx - 18, 250),
      Offset(tx, 200),
      Offset(tx + 18, 250),
      Offset(tx + 18, 420),
    ]),
    pal.far,
  );
  fillPath(canvas, circle(Offset(tx, 268), 9), pal.flower);
  var x = x0 - 10;
  while (x < x1) {
    final w = _between(rnd, 40, 58);
    final top = _between(rnd, 330, 370);
    fillPath(
      canvas,
      polygon([
        Offset(x, 430),
        Offset(x, top),
        Offset(x + w / 2, top - w * 0.55),
        Offset(x + w, top),
        Offset(x + w, 430),
      ]),
      pal.mid,
    );
    fillPath(canvas, rectangle(x + w * 0.66, top - w * 0.5, 7, 20), pal.mid);
    for (var k = 0; k < 2; k++) {
      if (rnd.nextDouble() < 0.6) {
        fillPath(
          canvas,
          rectangle(x + 9 + k * (w - 26), top + 18, 8, 11),
          pal.flower,
        );
      }
    }
    x += w + 4;
  }
  _hill(canvas, box, 440, 426, 436, pal.near);
  for (var i = 0; i < 7; i++) {
    final bx = x0 + 6 + i * 34;
    strokePath(
      canvas,
      polygon([Offset(bx, 470), Offset(bx + 26, 470)], closed: false),
      pal.detail,
      2,
    );
  }
}

void _jungle(Canvas canvas, Rect box, ScenePalette pal, Random rnd) {
  final x0 = box.left, x1 = box.right, y0 = box.top;
  _hill(canvas, box, 420, 400, 416, pal.near);
  for (final side in [-1, 1]) {
    final bx = side < 0 ? x0 : x1;
    for (var k = 0; k < 4; k++) {
      final y = 140 + k * 90 + _between(rnd, -10, 10);
      final length = 90 + _between(rnd, 0, 30);
      final a = side < 0 ? radians(-20.0 + k * 14) : radians(200.0 - k * 14);
      final base = Offset(bx, y);
      final tip = at(base, a, length);
      final mid = lerp(base, tip, 0.5) - const Offset(0, 12);
      final across = Offset(sin(a), -cos(a)) * 26;
      fillPath(
        canvas,
        smooth([base, mid + across, tip, mid - across], tension: 0.55),
        k.isOdd ? pal.mid : pal.far,
      );
      strokePath(
        canvas,
        smooth([base, mid, tip], closed: false),
        pal.detail,
        2,
      );
    }
  }
  for (var k = 0; k < 3; k++) {
    final x = x0 + 40 + k * 70 + _between(rnd, -10, 10);
    final pts = [
      Offset(x, y0 - 10),
      Offset(x + 10, y0 + 60),
      Offset(x - 6, y0 + 120 + k * 20),
    ];
    strokePath(canvas, smooth(pts, closed: false), pal.detail, 3);
    for (var j = 0; j < 3; j++) {
      fillPath(
        canvas,
        ellipse(
          Offset(pts[1].dx + (j - 1) * 6 + 8, y0 + 40 + j * 30 + k * 6),
          9,
          4.5,
          0.6,
        ),
        pal.mid,
      );
    }
  }
  for (var i = 0; i < 10; i++) {
    fillPath(
      canvas,
      ellipse(
        Offset(_between(rnd, x0, x1), _between(rnd, 470, 560)),
        10,
        3.5,
        _between(rnd, -0.3, 0.3),
      ),
      pal.detail,
    );
  }
}

void _savanna(Canvas canvas, Rect box, ScenePalette pal, Random rnd) {
  final x0 = box.left, x1 = box.right;
  fillPath(canvas, circle(const Offset(200, 330), 96), pal.sun);
  fillPath(canvas, rectangle(x0 - 10, 392, x1 - x0 + 20, 220), pal.mid);
  _hill(canvas, box, 430, 414, 426, pal.near);
  final tx = x0 + 28;
  strokePath(
    canvas,
    smooth([
      Offset(tx, 410),
      Offset(tx + 6, 350),
      Offset(tx - 4, 300),
      Offset(tx + 4, 270),
    ], closed: false),
    pal.far,
    8,
  );
  strokePath(
    canvas,
    smooth([
      Offset(tx + 4, 330),
      Offset(tx + 30, 300),
      Offset(tx + 40, 280),
    ], closed: false),
    pal.far,
    5,
  );
  fillPath(canvas, ellipse(Offset(tx + 10, 268), 60, 14), pal.far);
  fillPath(canvas, ellipse(Offset(tx + 44, 278), 36, 10), pal.far);
  for (var i = 0; i < 16; i++) {
    final x = _between(rnd, x0, x1), y = _between(rnd, 440, 560);
    for (final d in [-4.0, 0.0, 4.0]) {
      strokePath(
        canvas,
        polygon([Offset(x, y), Offset(x + d * 1.5, y - 12)], closed: false),
        pal.detail,
        2,
      );
    }
  }
}
