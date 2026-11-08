import 'dart:math';
import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

import '../card_design.dart';
import '../toolkit/geometry.dart';
import '../toolkit/ink.dart';
import '../toolkit/lettering.dart';
import '../toolkit/suit_shapes.dart';
import '../toon/cast.dart';
import '../toon/figure.dart';
import '../toon/scenery.dart';
import '../toon/toon.dart';
import 'limelight_glyphs.dart';

const _night = Color(0xFF121624);
const _night2 = Color(0xFF1D2238);
const _gold = Color(0xFFD9B45A);
const _goldLight = Color(0xFFF3DC93);
const _crimson = Color(0xFFD42C45);
const _ivory = Color(0xFFF2E8D0);

/// Midnight cards with stepped gold art deco frames. The face cards are
/// slender rubber hose animals, one species per suit, rim lit in gold under
/// a moonlit arch.
class DarkDeco extends CardDesign {
  const DarkDeco();

  @override
  String get id => 'dark_deco';

  @override
  String get name => 'Dark Deco';

  @override
  double get cornerRadius => 26 / 400;

  @override
  Rect get pipArea => const Rect.fromLTRB(152, 150, 248, 450);

  @override
  double get pipSize => 52;

  static final _font = GlyphFont(
    limelightUnitsPerEm,
    limelightCapHeight,
    limelightGlyphs,
  );

  static const _figureLook = Look(
    ink: Color(0xFF120E1C),
    lw: 2.6,
    weight: 0.3,
    shade: 0.3,
    highlight: 0.3,
    airbrush: 0.55,
    shadeColor: Color(0xFF2A1A48),
  );

  static const _scene = ScenePalette(
    far: Color(0xFF2E2A54),
    snow: Color(0xFF8F86B8),
    mid: Color(0xFF231F44),
    near: Color(0xFF19162F),
    detail: Color(0xFFA8874A),
    flower: Color(0xFFD9B45A),
    sun: Color(0xFFE9D49A),
  );

  static const _costumes = {
    Suit.hearts: Costume(
      main: Color(0xFFA3163A),
      trim: _gold,
      light: _ivory,
      pants: Color(0xFF241C38),
      shoe: Color(0xFF120E1C),
      suit: _crimson,
    ),
    Suit.diamonds: Costume(
      main: Color(0xFFB8581C),
      trim: _goldLight,
      light: _ivory,
      pants: Color(0xFF2A1C24),
      shoe: Color(0xFF120E1C),
      suit: _crimson,
    ),
    Suit.spades: Costume(
      main: Color(0xFF2B3F72),
      trim: _gold,
      light: _ivory,
      pants: Color(0xFF15172A),
      shoe: Color(0xFF0C0C14),
      suit: _ivory,
    ),
    Suit.clubs: Costume(
      main: Color(0xFF1E6656),
      trim: _gold,
      light: _ivory,
      pants: Color(0xFF14201E),
      shoe: Color(0xFF0C0C14),
      suit: _ivory,
    ),
  };

  static const _window = Rect.fromLTRB(96, 36, 304, 564);

  Color _suitColor(Suit suit) =>
      suit == Suit.hearts || suit == Suit.diamonds ? _crimson : _ivory;

  @override
  void paintGround(Canvas canvas, Card card) {
    canvas.drawRect(
      Offset.zero & cardDesignSize,
      Paint()
        ..shader = Gradient.linear(Offset.zero, const Offset(0, 600), [
          _night2,
          _night,
        ]),
    );
  }

  @override
  void paintFrame(Canvas canvas, Card card) {
    strokePath(
      canvas,
      _stepped(const Rect.fromLTRB(14, 14, 386, 586), 26),
      _gold,
      3,
    );
    strokePath(
      canvas,
      _stepped(const Rect.fromLTRB(22, 22, 378, 578), 22),
      alpha(_gold, 0.6),
      1.2,
    );
    // Fans in the middle of the long sides.
    for (final side in [-1, 1]) {
      final x = 200.0 + side * 186;
      for (var i = 0; i < 5; i++) {
        final a = pi / 2 + side * pi / 2 + (i - 2) * 0.3;
        strokePath(
          canvas,
          polygon([Offset(x, 300), at(Offset(x, 300), a, 14)], closed: false),
          _gold,
          1.5,
        );
      }
    }
  }

  @override
  void paintIndex(Canvas canvas, Card card) {
    const x = 64.0, cap = 54.0;
    final label = switch (card.rank) {
      Rank.jack => 'J',
      Rank.queen => 'Q',
      Rank.king => 'K',
      Rank.ace => 'A',
      final rank => rank.label,
    };
    final color = _suitColor(card.suit);
    fillPath(
      canvas,
      _font.text(label, x, 36 + cap, cap, tracking: label == '10' ? -0.1 : 0),
      color,
    );
    fillPath(
      canvas,
      suitShape(card.suit, const Offset(x, 36 + cap + 34), 38),
      color,
    );
  }

  @override
  void paintPip(Canvas canvas, Suit suit, Offset center, bool flipped) {
    final angle = flipped ? pi : 0.0;
    final shape = transformed(
      suitShape(suit, center, pipSize),
      angle: angle,
      about: center,
    );
    final inner = transformed(
      suitShape(suit, center, pipSize * 0.7),
      angle: angle,
      about: center,
    );
    strokePath(canvas, shape, _gold, 5);
    fillPath(canvas, shape, _suitColor(suit));
    strokePath(canvas, inner, alpha(_gold, 0.8), 1.4);
    final half = Offset(pipSize / 2, pipSize / 2);
    clipped(canvas, shape, () {
      canvas.drawRect(
        Rect.fromCircle(center: center, radius: pipSize),
        Paint()
          ..shader = Gradient.linear(
            center - half,
            center + half,
            [
              const Color(0x47FFFFFF),
              const Color(0x00FFFFFF),
              const Color(0x40000000),
            ],
            const [0, 0.5, 1],
          ),
      );
    });
  }

  @override
  void paintAce(Canvas canvas, Card card) {
    const c = Offset(200, 300);
    for (var i = 0; i < 36; i++) {
      final a = i * pi / 18;
      strokePath(
        canvas,
        polygon([at(c, a, 110), at(c, a, 190)], closed: false),
        alpha(_gold, i.isOdd ? 0.35 : 0.7),
        2,
      );
    }
    const featherLook = Look(
      ink: Color(0xFF5A4520),
      lw: 2,
      highlight: 0.4,
      shade: 0.25,
      weight: 0,
    );
    for (final side in [-1.0, 1.0]) {
      for (var i = 0; i < 6; i++) {
        final length = 112.0 - i * 13;
        final feather = Path()
          ..addRRect(
            RRect.fromLTRBR(0, -10, length, 10, const Radius.circular(10)),
          );
        final shape = transformed(
          feather,
          dx: c.dx + side * 74,
          dy: c.dy - 36 + i * 18,
          sx: side,
          sy: 1,
          angle: side * (-0.32 + i * 0.12),
        );
        inkShape(
          canvas,
          shape,
          i.isEven ? _gold : lighter(_gold, 0.2),
          featherLook,
        );
      }
    }
    inkShape(
      canvas,
      circle(c, 92),
      _night2,
      const Look(ink: _gold, lw: 4, highlight: 0, shade: 0, weight: 0),
    );
    strokePath(canvas, circle(c, 80), _gold, 1.5);
    const size = 118.0;
    inkShape(
      canvas,
      suitShape(card.suit, c + const Offset(0, 4), size),
      _suitColor(card.suit),
      const Look(
        ink: _gold,
        lw: 3.5 * size / 90,
        highlight: 0.6,
        shade: 0.25,
        weight: 0,
      ),
    );
  }

  @override
  void paintFace(Canvas canvas, Card card) {
    final window = _stepped(_window, 22);
    clipped(canvas, window, () {
      _sky(canvas, card);
      paintScene(canvas, animalOf(card.suit), _window, _scene, card.rank.index);
    });
    strokePath(canvas, window, _gold, 3);
    strokePath(
      canvas,
      _stepped(_window.inflate(6), 26),
      alpha(_gold, 0.55),
      1.2,
    );

    final toon = castToon(card.rank, card.suit, _costumes[card.suit]!);
    final recorder = PictureRecorder();
    final figureCanvas = Canvas(recorder);
    figureCanvas.translate(200, 300);
    figureCanvas.scale(0.86);
    figureCanvas.translate(-200, -300);
    paintToon(figureCanvas, toon, _figureLook);
    final figure = recorder.endRecording();
    // A gold rim of light around the figure.
    canvas.saveLayer(
      null,
      Paint()
        ..imageFilter = ImageFilter.blur(sigmaX: 5, sigmaY: 5)
        ..colorFilter = const ColorFilter.mode(
          Color(0xB3F2C766),
          BlendMode.srcIn,
        ),
    );
    canvas.drawPicture(figure);
    canvas.restore();
    canvas.drawPicture(figure);
    figure.dispose();
  }

  void _sky(Canvas canvas, Card card) {
    canvas.drawRect(
      _window,
      Paint()
        ..shader = Gradient.linear(
          Offset(0, _window.top),
          const Offset(0, 420),
          [const Color(0xFF141A36), const Color(0xFF6B3A5E)],
        ),
    );
    final rnd = Random(card.index);
    double between(double a, double b) => a + rnd.nextDouble() * (b - a);
    for (var i = 0; i < 30; i++) {
      fillPath(
        canvas,
        circle(Offset(between(90, 310), between(40, 300)), between(0.6, 1.6)),
        alpha(_goldLight, between(0.4, 0.9)),
      );
    }
    const moon = Offset(200, 330);
    for (var i = 0; i < 28; i++) {
      final a = pi + i * pi / 27;
      strokePath(
        canvas,
        polygon([at(moon, a, 110), at(moon, a, 320)], closed: false),
        alpha(_gold, i.isOdd ? 0.22 : 0.4),
        1.6,
      );
    }
    canvas.drawRect(
      _window,
      Paint()
        ..shader = Gradient.radial(
          moon,
          160,
          [alpha(_goldLight, 0.55), alpha(_goldLight, 0)],
          [20 / 160, 1],
        ),
    );
    fillPath(canvas, circle(moon, 92), const Color(0xF2EFDCA6));
  }

  @override
  void paintFinish(Canvas canvas, Card card) {
    // Vignette: the edges darken towards the corners.
    canvas.save();
    canvas.translate(200, 300);
    canvas.scale(200, 300);
    const dark = Color(0xFF05050D);
    canvas.drawRect(
      const Rect.fromLTRB(-1.5, -1.5, 1.5, 1.5),
      Paint()
        ..shader = Gradient.radial(
          Offset.zero,
          1.42,
          [
            alpha(dark, 0),
            alpha(dark, 0.07),
            alpha(dark, 0.2),
            alpha(dark, 0.3),
          ],
          [0.39, 0.63, 0.85, 1],
        ),
    );
    canvas.restore();
  }
}

/// A rectangle whose corners are cut in steps, an art deco classic.
Path _stepped(Rect r, double n) {
  final x0 = r.left, y0 = r.top, x1 = r.right, y1 = r.bottom;
  return polygon([
    Offset(x0 + n, y0),
    Offset(x1 - n, y0),
    Offset(x1 - n, y0 + n / 2),
    Offset(x1 - n / 2, y0 + n / 2),
    Offset(x1 - n / 2, y0 + n),
    Offset(x1, y0 + n),
    Offset(x1, y1 - n),
    Offset(x1 - n / 2, y1 - n),
    Offset(x1 - n / 2, y1 - n / 2),
    Offset(x1 - n, y1 - n / 2),
    Offset(x1 - n, y1),
    Offset(x0 + n, y1),
    Offset(x0 + n, y1 - n / 2),
    Offset(x0 + n / 2, y1 - n / 2),
    Offset(x0 + n / 2, y1 - n),
    Offset(x0, y1 - n),
    Offset(x0, y0 + n),
    Offset(x0 + n / 2, y0 + n),
    Offset(x0 + n / 2, y0 + n / 2),
    Offset(x0 + n, y0 + n / 2),
  ]);
}
