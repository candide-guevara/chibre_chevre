import 'package:flutter/widgets.dart';

/// A left-pointing arrow drawn with lines, so that it never depends on the
/// icon font being available.
class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    final icon = IconTheme.of(context);
    final size = icon.size ?? 24;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _BackArrowPainter(icon.color ?? const Color(0xFF000000)),
      ),
    );
  }
}

class _BackArrowPainter extends CustomPainter {
  _BackArrowPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.square;
    canvas
      ..drawLine(Offset(5 * s, 12 * s), Offset(19 * s, 12 * s), paint)
      ..drawLine(Offset(5 * s, 12 * s), Offset(11 * s, 6 * s), paint)
      ..drawLine(Offset(5 * s, 12 * s), Offset(11 * s, 18 * s), paint);
  }

  @override
  bool shouldRepaint(_BackArrowPainter old) => old.color != color;
}
