import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

import 'card_design.dart';

/// A deck whose cards are images shipped in the app, at
/// `assets/cards/<id>/<card>.<format>`, e.g. `assets/cards/vintage/HJ.webp`.
/// Until an image is loaded, the card is a plain [blank] card.
class BundledCardDesign extends CardDesign {
  const BundledCardDesign({
    required this.id,
    required this.name,
    required this.version,
    required this.cornerRadius,
    required this.blank,
  });

  @override
  final String id;

  @override
  final String name;

  @override
  final int version;

  @override
  final double cornerRadius;

  final Color blank;

  @override
  void paint(Canvas canvas, Card card) => canvas.drawRRect(
    RRect.fromRectAndRadius(
      Offset.zero & cardDesignSize,
      Radius.circular(cornerRadius * cardDesignSize.width),
    ),
    Paint()..color = blank,
  );
}
