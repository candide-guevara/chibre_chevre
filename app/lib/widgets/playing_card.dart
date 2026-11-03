import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart' hide Card;

import '../card_art/card_face_painter.dart';
import '../labels.dart';
import '../theme/chibre_theme.dart';

const cardAspectRatio = 1.5;

/// The front of a card. Disabled cards are dimmed; selected ones are raised
/// and outlined.
class PlayingCard extends StatelessWidget {
  const PlayingCard({
    super.key,
    required this.card,
    required this.style,
    required this.width,
    this.enabled = true,
    this.selected = false,
    this.onTap,
  });

  final Card card;
  final CardStyle style;
  final double width;
  final bool enabled;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget face = RepaintBoundary(
      child: CustomPaint(
        size: Size(width, width * cardAspectRatio),
        painter: CardFacePainter(card, style),
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
          border: Border.all(color: ChibreColors.brass, width: 3),
          borderRadius: BorderRadius.circular(width * 0.08),
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
          duration: const Duration(milliseconds: 120),
          offset: Offset(0, selected ? -0.15 : 0),
          child: face,
        ),
      ),
    );
  }
}
