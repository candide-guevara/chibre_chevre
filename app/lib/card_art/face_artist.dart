import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';

import '../theme/chibre_theme.dart';
import 'cow_artist.dart';
import 'monkey_artist.dart';
import 'rubber_hose.dart';
import 'suit_symbol.dart';
import 'zebra_artist.dart';

FaceArtist faceArtistFor(CardStyle style) => switch (style) {
  CardStyle.monkey => const MonkeyArtist(),
  CardStyle.cow => const CowArtist(),
  CardStyle.zebra => const ZebraArtist(),
};

/// Draws the jack, queen and king of a card set. The body, arms, gloves and
/// headgear are shared; each animal only draws its head.
abstract class FaceArtist {
  const FaceArtist();

  /// Paints the head centred on [center], [size] wide, and returns the point
  /// where headgear sits.
  Offset paintHead(Canvas canvas, Offset center, double size);

  void paintFigure(Canvas canvas, Rect box, Rank rank, Suit suit) {
    final w = box.width, h = box.height;
    Offset at(double x, double y) => box.topLeft + Offset(w * x, h * y);
    final stroke = w * 0.025;
    final garment = suit == Suit.spades || suit == Suit.clubs
        ? const Color(0xFF46524E)
        : suitColor(suit);

    final body = Path()
      ..moveTo(at(0.3, 0.6).dx, at(0.3, 0.6).dy)
      ..quadraticBezierTo(
        at(0.5, 0.52).dx,
        at(0.5, 0.52).dy,
        at(0.7, 0.6).dx,
        at(0.7, 0.6).dy,
      )
      ..quadraticBezierTo(
        at(0.86, 0.85).dx,
        at(0.86, 0.85).dy,
        at(0.8, 1.0).dx,
        at(0.8, 1.0).dy,
      )
      ..lineTo(at(0.2, 1.0).dx, at(0.2, 1.0).dy)
      ..quadraticBezierTo(
        at(0.14, 0.85).dx,
        at(0.14, 0.85).dy,
        at(0.3, 0.6).dx,
        at(0.3, 0.6).dy,
      )
      ..close();
    fillAndInk(canvas, body, garment, stroke);
    _paintCollar(canvas, rank, at, w, stroke);

    noodleArm(canvas, at(0.32, 0.66), at(0.2, 0.86), -w * 0.12, stroke * 2.2);
    noodleArm(canvas, at(0.68, 0.66), at(0.8, 0.5), -w * 0.1, stroke * 2.2);
    whiteGlove(canvas, at(0.2, 0.86), w * 0.15);
    whiteGlove(canvas, at(0.8, 0.5), w * 0.15);
    // The lower hand shows the suit on an ivory badge.
    final symbolSize = w * 0.16;
    fillAndInk(
      canvas,
      oval(at(0.2, 0.72), symbolSize * 1.5, symbolSize * 1.5),
      ChibreColors.ivory,
      stroke * 0.8,
    );
    paintSuit(
      canvas,
      suit,
      Rect.fromCenter(
        center: at(0.2, 0.72),
        width: symbolSize,
        height: symbolSize,
      ),
    );

    final hatPoint = paintHead(canvas, at(0.5, 0.36), w * 0.5);
    switch (rank) {
      case Rank.jack:
        beret(canvas, hatPoint, w * 0.34, garment);
      case Rank.queen:
        crown(canvas, hatPoint, w * 0.24, w * 0.1, 3);
      case Rank.king:
        crown(canvas, hatPoint, w * 0.34, w * 0.18, 4);
      default:
        break;
    }
  }

  void _paintCollar(
    Canvas canvas,
    Rank rank,
    Offset Function(double, double) at,
    double w,
    double stroke,
  ) {
    switch (rank) {
      case Rank.jack:
        // Bow tie.
        final tie = Path()
          ..moveTo(at(0.5, 0.6).dx, at(0.5, 0.6).dy)
          ..lineTo(at(0.42, 0.56).dx, at(0.42, 0.56).dy)
          ..lineTo(at(0.42, 0.64).dx, at(0.42, 0.64).dy)
          ..close()
          ..moveTo(at(0.5, 0.6).dx, at(0.5, 0.6).dy)
          ..lineTo(at(0.58, 0.56).dx, at(0.58, 0.56).dy)
          ..lineTo(at(0.58, 0.64).dx, at(0.58, 0.64).dy)
          ..close();
        fillAndInk(canvas, tie, ChibreColors.ivory, stroke * 0.8);
      case Rank.queen:
        // Pearl necklace.
        for (var i = 0; i < 7; i++) {
          final x = 0.38 + i * 0.04;
          final y = 0.6 + 0.03 * (1 - ((i - 3) / 3) * ((i - 3) / 3));
          fillAndInk(
            canvas,
            oval(at(x, y), w * 0.035, w * 0.035),
            ChibreColors.ivory,
            stroke * 0.4,
          );
        }
      case Rank.king:
        // Ermine cape collar.
        final cape = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromPoints(at(0.28, 0.57), at(0.72, 0.66)),
              Radius.circular(w * 0.04),
            ),
          );
        fillAndInk(canvas, cape, ChibreColors.ivory, stroke * 0.8);
        for (final x in [0.36, 0.5, 0.64]) {
          canvas.drawCircle(
            at(x, 0.615),
            w * 0.012,
            fillPaint(ChibreColors.ink),
          );
        }
      default:
        break;
    }
  }
}
