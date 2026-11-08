import 'dart:typed_data';
import 'dart:ui';

/// Text drawn from glyph outlines baked into the code, so cards need no font
/// files.
class GlyphFont {
  GlyphFont(
    this.unitsPerEm,
    num capHeight,
    Map<String, (double, String)> glyphs,
  ) : capHeight = capHeight.toDouble(),
      _glyphs = {
        for (final MapEntry(:key, :value) in glyphs.entries)
          key: (value.$1, _parse(value.$2)),
      };

  final int unitsPerEm;
  final double capHeight;
  final Map<String, (double, Path)> _glyphs;

  /// [text] as a path whose capitals are [capSize] tall, standing on
  /// [baseline] and centred on [x]. [tracking] is in em.
  Path text(
    String text,
    double x,
    double baseline,
    double capSize, {
    double tracking = 0,
  }) {
    final em = capSize * unitsPerEm / capHeight;
    final s = em / unitsPerEm;
    var width = -tracking * em;
    for (final ch in text.split('')) {
      width += _glyphs[ch]!.$1 * s + tracking * em;
    }
    final out = Path();
    var cx = x - width / 2;
    for (final ch in text.split('')) {
      final (advance, outline) = _glyphs[ch]!;
      final matrix = Float64List.fromList([
        s,
        0,
        0,
        0,
        0,
        -s,
        0,
        0,
        0,
        0,
        1,
        0,
        cx,
        baseline,
        0,
        1,
      ]);
      out.addPath(outline.transform(matrix), Offset.zero);
      cx += advance * s + tracking * em;
    }
    return out;
  }

  static Path _parse(String data) {
    final path = Path();
    final tokens = RegExp(r'[MLQCZ]|-?[\d.]+')
        .allMatches(data)
        .map((m) => m[0]!)
        .toList();
    var i = 0;
    double next() => double.parse(tokens[i++]);
    while (i < tokens.length) {
      switch (tokens[i++]) {
        case 'M':
          path.moveTo(next(), next());
        case 'L':
          path.lineTo(next(), next());
        case 'Q':
          path.quadraticBezierTo(next(), next(), next(), next());
        case 'C':
          path.cubicTo(next(), next(), next(), next(), next(), next());
        case 'Z':
          path.close();
      }
    }
    return path;
  }
}
