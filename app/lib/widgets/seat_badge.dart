import 'package:flutter/material.dart';

import '../theme/chibre_theme.dart';

/// A player's name around the table, highlighted when it's their turn.
class SeatBadge extends StatelessWidget {
  const SeatBadge({super.key, required this.nickname, required this.isTurn});

  final String nickname;
  final bool isTurn;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isTurn ? UiColors.accent : UiColors.seatBadge,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        nickname,
        style: text.labelLarge?.copyWith(
          color: isTurn ? UiColors.onAccent : UiColors.text,
          fontSize: (text.labelLarge?.fontSize ?? 14) * 1.2,
        ),
      ),
    );
  }
}
