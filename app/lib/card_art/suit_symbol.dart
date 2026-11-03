import 'dart:typed_data';
import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

import '../theme/chibre_theme.dart';

Color suitColor(Suit suit) => suit == Suit.diamonds || suit == Suit.hearts
    ? ChibreColors.red
    : ChibreColors.ink;

/// The outline of a suit symbol filling [box].
Path suitPath(Suit suit, Rect box) => switch (suit) {
  Suit.diamonds => _diamond(box),
  Suit.hearts => _heart(box),
  Suit.spades => _spade(box),
  Suit.clubs => _club(box),
};

Path _diamond(Rect box) {
  final c = box.center;
  return Path()
    ..moveTo(c.dx, box.top)
    ..quadraticBezierTo(
      c.dx + box.width * 0.12,
      c.dy - box.height * 0.12,
      box.right,
      c.dy,
    )
    ..quadraticBezierTo(
      c.dx + box.width * 0.12,
      c.dy + box.height * 0.12,
      c.dx,
      box.bottom,
    )
    ..quadraticBezierTo(
      c.dx - box.width * 0.12,
      c.dy + box.height * 0.12,
      box.left,
      c.dy,
    )
    ..quadraticBezierTo(
      c.dx - box.width * 0.12,
      c.dy - box.height * 0.12,
      c.dx,
      box.top,
    )
    ..close();
}

Path _heart(Rect box) {
  final l = box.left, t = box.top, w = box.width, h = box.height;
  return Path()
    ..moveTo(l + w / 2, t + h * 0.28)
    ..cubicTo(l + w * 0.45, t, l, t, l, t + h * 0.32)
    ..cubicTo(l, t + h * 0.6, l + w * 0.4, t + h * 0.78, l + w / 2, t + h)
    ..cubicTo(
      l + w * 0.6,
      t + h * 0.78,
      l + w,
      t + h * 0.6,
      l + w,
      t + h * 0.32,
    )
    ..cubicTo(l + w, t, l + w * 0.55, t, l + w / 2, t + h * 0.28)
    ..close();
}

Path _spade(Rect box) {
  final l = box.left, t = box.top, w = box.width, h = box.height;
  final leaf = Rect.fromLTWH(l, t, w, h * 0.78);
  // An upside down heart.
  final flip = Float64List.fromList([
    1, 0, 0, 0, //
    0, -1, 0, 0, //
    0, 0, 1, 0, //
    0, leaf.top + leaf.bottom, 0, 1,
  ]);
  return Path()
    ..addPath(_heart(leaf).transform(flip), Offset.zero)
    ..addPath(_stem(box), Offset.zero);
}

Path _club(Rect box) {
  final l = box.left, t = box.top, w = box.width, h = box.height;
  final r = w * 0.24;
  return Path()
    ..addOval(Rect.fromCircle(center: Offset(l + w / 2, t + r), radius: r))
    ..addOval(Rect.fromCircle(center: Offset(l + r, t + h * 0.56), radius: r))
    ..addOval(
      Rect.fromCircle(center: Offset(l + w - r, t + h * 0.56), radius: r),
    )
    ..addOval(
      Rect.fromCircle(center: Offset(l + w / 2, t + h * 0.5), radius: r * 0.7),
    )
    ..addPath(_stem(box), Offset.zero);
}

Path _stem(Rect box) {
  final c = box.center.dx, w = box.width, h = box.height;
  return Path()
    ..moveTo(c, box.top + h * 0.55)
    ..quadraticBezierTo(c, box.bottom, c - w * 0.22, box.bottom)
    ..lineTo(c + w * 0.22, box.bottom)
    ..quadraticBezierTo(c, box.bottom, c, box.top + h * 0.55)
    ..close();
}

void paintSuit(Canvas canvas, Suit suit, Rect box) =>
    canvas.drawPath(suitPath(suit, box), Paint()..color = suitColor(suit));
