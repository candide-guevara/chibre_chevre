import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/rendering.dart';

import 'card_design.dart';

/// Paints the front of [card] in [design], scaled to the canvas.
///
/// Each card is recorded once per design and replayed afterwards, so the art
/// is only computed the first time a card is shown.
class CardFacePainter extends CustomPainter {
  const CardFacePainter(this.card, this.design);

  final Card card;
  final CardDesign design;

  static final _pictures = <(String, int), Picture>{};

  static Picture _record(CardDesign design, Card card) =>
      _pictures.putIfAbsent((design.id, card.index), () {
        final recorder = PictureRecorder();
        design.paint(Canvas(recorder), card);
        return recorder.endRecording();
      });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(
      size.width / cardDesignSize.width,
      size.height / cardDesignSize.height,
    );
    canvas.drawPicture(_record(design, card));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CardFacePainter oldDelegate) =>
      oldDelegate.card != card || oldDelegate.design != design;
}
