import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme/chibre_theme.dart';
import 'trump_badge.dart';

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
    return Semantics(
      label: Strings.trumpIs(mode),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.trumpLabel, style: text.titleMedium),
          const SizedBox(width: 8),
          TrumpBadge(mode: mode, size: _size),
          if (multiplier > 1) ...[
            const SizedBox(width: 6),
            Text(
              Strings.multiplier(multiplier),
              style: text.titleLarge?.copyWith(color: UiColors.accent),
            ),
          ],
        ],
      ),
    );
  }
}
