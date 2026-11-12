import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../theme/chibre_theme.dart';
import 'trump_badge.dart';

/// A player's name around the table, highlighted when it's their turn,
/// followed by the trump when it was theirs to choose.
class SeatBadge extends StatelessWidget {
  const SeatBadge({
    super.key,
    required this.nickname,
    required this.isTurn,
    this.trump,
  });

  final String nickname;
  final bool isTurn;
  final TrumpMode? trump;

  /// The size of the trump badge, relative to the name's font size.
  static const _trumpScale = 1.3;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final fontSize = (text.labelLarge?.fontSize ?? 14) * 1.2;
    final style = text.labelLarge?.copyWith(
      color: isTurn ? UiColors.onAccent : UiColors.text,
      fontSize: fontSize,
    );
    return AnimatedContainer(
      duration: const SessionTiming().turnBadge,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isTurn ? UiColors.accent : UiColors.seatBadge,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(nickname, style: style),
          if (trump != null) ...[
            const SizedBox(width: 6),
            TrumpBadge(mode: trump!, size: fontSize * _trumpScale),
          ],
        ],
      ),
    );
  }
}
