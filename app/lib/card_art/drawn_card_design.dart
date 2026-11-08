import 'dart:math';
import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

import 'card_design.dart';
import 'pip_layout.dart';

/// A design drawn in code. [paint] lays a card out the traditional way:
/// ground, then pips, ace or face, then frame and the two corner indices.
/// Designs fill in the parts.
abstract class DrawnCardDesign extends CardDesign {
  const DrawnCardDesign();

  /// Where the pips of number cards go, in the 400×600 box.
  Rect get pipArea;

  /// Height of the pips of number cards.
  double get pipSize;

  @override
  void paint(Canvas canvas, Card card) {
    final outline = RRect.fromRectAndRadius(
      Offset.zero & cardDesignSize,
      Radius.circular(cornerRadius * cardDesignSize.width),
    );
    canvas.save();
    canvas.clipRRect(outline);
    paintGround(canvas, card);
    switch (card.rank) {
      case Rank.ace:
        paintAce(canvas, card);
      case Rank.jack || Rank.queen || Rank.king:
        paintFace(canvas, card);
      default:
        paintPips(canvas, card);
    }
    paintFrame(canvas, card);
    paintIndex(canvas, card);
    canvas.save();
    canvas.translate(cardDesignSize.width, cardDesignSize.height);
    canvas.rotate(pi);
    paintIndex(canvas, card);
    canvas.restore();
    paintFinish(canvas, card);
    canvas.restore();
  }

  void paintGround(Canvas canvas, Card card);

  void paintFrame(Canvas canvas, Card card) {}

  /// The rank and suit in the top left corner.
  void paintIndex(Canvas canvas, Card card);

  void paintAce(Canvas canvas, Card card);

  /// The jack, queen or king.
  void paintFace(Canvas canvas, Card card);

  void paintPips(Canvas canvas, Card card) {
    final area = pipArea;
    for (final position in pipPositions(card.rank)) {
      paintPip(
        canvas,
        card.suit,
        Offset(
          area.left + area.width * position.dx,
          area.top + area.height * position.dy,
        ),
        position.dy > 0.5,
      );
    }
  }

  /// One suit symbol of a number card, upside down when [flipped].
  void paintPip(Canvas canvas, Suit suit, Offset center, bool flipped);

  /// Drawn over everything, e.g. a vignette.
  void paintFinish(Canvas canvas, Card card) {}
}
