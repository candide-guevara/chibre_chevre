import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart' hide Card;

import '../card_art/card_designs.dart';
import '../card_art/card_face_painter.dart';
import '../card_art/card_images.dart';
import '../labels.dart';
import '../theme/chibre_theme.dart';

const cardAspectRatio = 1.5;

/// The width of the largest cards, those in the hand.
const maxCardWidth = 90.0;

/// The front of a card. Disabled cards are dimmed; selected ones are raised
/// and outlined.
class PlayingCard extends StatelessWidget {
  const PlayingCard({
    super.key,
    required this.card,
    required this.width,
    this.enabled = true,
    this.selected = false,
    this.onTap,
  });

  final Card card;
  final double width;
  final bool enabled;
  final bool selected;
  final VoidCallback? onTap;

  /// How far a selected card rises, in card heights.
  static const selectedRise = 0.15;

  @override
  Widget build(BuildContext context) {
    final design = CardDesignScope.of(context);
    Widget face = RepaintBoundary(
      child: CustomPaint(
        size: Size(width, width * cardAspectRatio),
        painter: CardFacePainter(card, CardImages.of(design)),
      ),
    );
    if (!enabled) {
      face = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Color(0x66000000),
          BlendMode.srcATop,
        ),
        child: face,
      );
    }
    if (selected) {
      face = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border.all(color: UiColors.accent, width: 3),
          borderRadius: BorderRadius.circular(width * design.cornerRadius),
        ),
        child: face,
      );
    }
    return Semantics(
      label: cardName(card),
      button: onTap != null,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedSlide(
          duration: const SessionTiming().selection,
          offset: Offset(0, selected ? -selectedRise : 0),
          child: face,
        ),
      ),
    );
  }
}
