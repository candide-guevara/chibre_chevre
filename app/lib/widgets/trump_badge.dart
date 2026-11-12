import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme/chibre_theme.dart';
import 'suit_icon.dart';

/// The trump suit (or ⬇ / ⬆ for Obenabe / Undenufe) on an ivory disc.
class TrumpBadge extends StatelessWidget {
  const TrumpBadge({super.key, required this.mode, required this.size});

  final TrumpMode mode;
  final double size;

  /// The share of the disc taken by the suit.
  static const _suitShare = 0.6;

  @override
  Widget build(BuildContext context) {
    final suit = mode.trumpSuit;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: UiColors.trumpBadge,
        shape: BoxShape.circle,
      ),
      child: suit == null
          ? Text(
              Strings.modeSymbol(mode),
              style: TextStyle(
                color: UiColors.onTrumpBadge,
                fontSize: size * _suitShare,
                height: 1,
              ),
            )
          : SuitIcon(suit, size: size * _suitShare),
    );
  }
}
