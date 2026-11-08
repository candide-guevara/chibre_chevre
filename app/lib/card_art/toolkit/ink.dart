import 'dart:ui';

import 'geometry.dart';

const inkBlack = Color(0xFF1B1410);
const paperWhite = Color(0xFFFFFDF6);

Color darker(Color c, [double t = 0.3]) =>
    Color.lerp(c, const Color(0xFF000000).withValues(alpha: c.a), t)!;

Color lighter(Color c, [double t = 0.3]) =>
    Color.lerp(c, const Color(0xFFFFFFFF).withValues(alpha: c.a), t)!;

Color alpha(Color c, double a) => c.withValues(alpha: a);

/// How a design inks and shades its shapes.
class Look {
  const Look({
    this.ink = inkBlack,
    this.lw = 5,
    this.weight = 0.45,
    this.shade = 0.22,
    this.shadeOffset = const Offset(-0.09, -0.11),
    this.highlight = 0.55,
    this.airbrush = 0,
    this.shadeColor,
  });

  final Color ink;

  /// Half the outline width.
  final double lw;

  /// Extra ink on the shadow side.
  final double weight;

  /// Strength of the cel shadow crescent.
  final double shade;
  final Offset shadeOffset;

  /// Strength of the specular highlight.
  final double highlight;

  /// Strength of the soft radial shading.
  final double airbrush;
  final Color? shadeColor;
}

void fillPath(Canvas canvas, Path path, Color color) =>
    canvas.drawPath(path, Paint()..color = color);

void strokePath(Canvas canvas, Path path, Color color, double width) =>
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

void clipped(Canvas canvas, Path clip, void Function() draw) {
  canvas.save();
  canvas.clipPath(clip);
  draw();
  canvas.restore();
}

/// A filled shape with a rubber hose ink outline (heavier on the shadow
/// side), airbrushed volume, a cel shadow crescent and a highlight.
void inkShape(
  Canvas canvas,
  Path shape,
  Color color,
  Look look, {
  double? lw,
  double? shade,
  double? highlight,
  double? airbrush,
  bool outline = true,
}) {
  final width = lw ?? look.lw;
  final shadeAmount = shade ?? look.shade;
  final highlightAmount = highlight ?? look.highlight;
  final airbrushAmount = airbrush ?? look.airbrush;
  final box = shape.getBounds();
  final w = box.width, h = box.height;
  if (outline && width > 0) {
    if (look.weight > 0) {
      final d = width * look.weight;
      strokePath(
        canvas,
        transformed(shape, dx: d, dy: d * 1.2),
        look.ink,
        width * 2,
      );
    }
    strokePath(canvas, shape, look.ink, width * 2);
  }
  fillPath(canvas, shape, color);
  if (airbrushAmount == 0 && shadeAmount == 0 && highlightAmount == 0) return;
  canvas.save();
  canvas.clipPath(shape);
  if (airbrushAmount > 0) {
    final dark = look.shadeColor ?? darker(color, 0.55);
    canvas.drawRect(
      box,
      Paint()
        ..shader = Gradient.radial(
          Offset(box.left + w * 0.35, box.top + h * 0.3),
          (w > h ? w : h) * 0.95,
          [
            alpha(const Color(0xFFFFFFFF), 0.18 * airbrushAmount),
            alpha(dark, 0),
            alpha(dark, 0.75 * airbrushAmount),
          ],
          const [0, 0.45, 1],
        ),
    );
  }
  if (shadeAmount > 0) {
    final dark = look.shadeColor ?? darker(color, 0.45);
    final crescent = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(box.inflate(50))
      ..addPath(
        transformed(
          shape,
          dx: look.shadeOffset.dx * w,
          dy: look.shadeOffset.dy * h,
        ),
        Offset.zero,
      );
    fillPath(canvas, crescent, alpha(dark, shadeAmount));
  }
  if (highlightAmount > 0) {
    fillPath(
      canvas,
      ellipse(
        Offset(box.left + w * 0.3, box.top + h * 0.22),
        w * 0.11 > 1.5 ? w * 0.11 : 1.5,
        h * 0.07 > 1.2 ? h * 0.07 : 1.2,
        -0.6,
      ),
      alpha(const Color(0xFFFFFFFF), 0.85 * highlightAmount),
    );
  }
  canvas.restore();
}

/// An inked shape with the figure defaults: no highlight unless asked.
void part(
  Canvas canvas,
  Path shape,
  Color color,
  Look look, {
  double? shade,
  double highlight = 0,
  double? lw,
}) => inkShape(
  canvas,
  shape,
  color,
  look,
  lw: lw,
  shade: shade,
  highlight: highlight,
);

/// A stroke along a smooth curve through [points].
void line(
  Canvas canvas,
  List<Offset> points,
  Look look, [
  double? width,
  Color? color,
]) => strokePath(
  canvas,
  smooth(points, closed: false),
  color ?? look.ink,
  width ?? look.lw,
);

/// A tapered ink stroke.
void brush(
  Canvas canvas,
  List<Offset> points,
  double w0,
  double w1,
  Look look, [
  Color? color,
]) => fillPath(canvas, noodle(points, w0, w1), color ?? look.ink);
