import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import '../card_art/suit_symbol.dart';
import '../labels.dart';
import '../theme/chibre_theme.dart';

/// "Atout :" followed by the trump suit (or Obenabe / Undenufe) on an ivory
/// badge, and the multiplier when there is one.
class TrumpIndicator extends StatelessWidget {
  const TrumpIndicator({super.key, required this.mode, this.multiplier = 1});

  final TrumpMode mode;
  final int multiplier;

  static const _size = 36.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final suit = mode.trumpSuit;
    return Semantics(
      label: 'Atout : ${modeName(mode)}',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Atout :', style: text.titleMedium),
          const SizedBox(width: 8),
          Container(
            width: _size,
            height: _size,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: ChibreColors.ivory,
              shape: BoxShape.circle,
            ),
            child: suit == null
                ? Text(
                    modeSymbol(mode),
                    style: text.titleLarge?.copyWith(
                      color: ChibreColors.feltDark,
                    ),
                  )
                : CustomPaint(
                    size: const Size.square(_size * 0.6),
                    painter: _SuitPainter(suit),
                  ),
          ),
          if (multiplier > 1) ...[
            const SizedBox(width: 6),
            Text(
              '×$multiplier',
              style: text.titleLarge?.copyWith(color: ChibreColors.brass),
            ),
          ],
        ],
      ),
    );
  }
}

class _SuitPainter extends CustomPainter {
  const _SuitPainter(this.suit);

  final Suit suit;

  @override
  void paint(Canvas canvas, Size size) =>
      paintSuit(canvas, suit, Offset.zero & size);

  @override
  bool shouldRepaint(_SuitPainter old) => old.suit != suit;
}
