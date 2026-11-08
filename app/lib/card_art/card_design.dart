import 'dart:ui';

/// The look of a whole deck: one image per card shipped in the app, at
/// `assets/cards/<id>/<card>.webp`, e.g. `assets/cards/vintage/HJ.webp`.
/// To add a design, list it in `cardDesigns`.
class CardDesign {
  const CardDesign({
    required this.id,
    required this.name,
    required this.cornerRadius,
    required this.blank,
  });

  /// A stable identifier, saved in the player's preferences; also the folder
  /// of its images.
  final String id;

  /// The name shown to players.
  final String name;

  /// Corner radius, as a fraction of the card width.
  final double cornerRadius;

  /// The colour of a card whose image is not loaded yet.
  final Color blank;
}
