import 'package:flutter/material.dart';

import '../theme/chibre_theme.dart';

/// A player's name around the table, highlighted when it's their turn.
class SeatBadge extends StatelessWidget {
  const SeatBadge({
    super.key,
    required this.nickname,
    required this.isTurn,
    this.isTrumpChooser = false,
  });

  final String nickname;
  final bool isTurn;
  final bool isTrumpChooser;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isTurn ? ChibreColors.brass : ChibreColors.feltDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isTrumpChooser ? '$nickname •' : nickname,
        style: text.labelLarge?.copyWith(
          color: isTurn ? ChibreColors.feltDark : ChibreColors.ivory,
        ),
      ),
    );
  }
}
