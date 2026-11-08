import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

/// Every design paints its cards in this box; the painter scales it to the
/// card on screen.
const cardDesignSize = Size(400, 600);

/// The look of a whole deck. To add a design, extend [DrawnCardDesign] (art
/// drawn in code) or use a [BundledCardDesign] (images shipped in the app),
/// and list it in `cardDesigns`.
abstract class CardDesign {
  const CardDesign();

  /// A stable identifier, saved in the player's preferences.
  String get id;

  /// The name shown to players.
  String get name;

  /// Bump whenever the art changes, so the images saved on the phones are
  /// rendered again.
  int get version;

  /// Corner radius, as a fraction of the card width.
  double get cornerRadius;

  /// Paints [card] in the 400×600 box.
  void paint(Canvas canvas, Card card);
}
