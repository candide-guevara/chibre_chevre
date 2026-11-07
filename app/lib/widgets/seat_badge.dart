import 'package:flutter/material.dart';

import '../theme/chibre_theme.dart';

/// A player's name around the table, highlighted when it's their turn, with
/// their announcements.
class SeatBadge extends StatelessWidget {
  const SeatBadge({
    super.key,
    required this.nickname,
    required this.isTurn,
    this.isTrumpChooser = false,
    this.announcement,
  });

  final String nickname;
  final bool isTurn;
  final bool isTrumpChooser;

  /// Melds or Stöck announced, already formatted.
  final String? announcement;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
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
        ),
        // The line is always there, so the name does not move when an
        // announcement appears.
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            announcement ?? '',
            style: text.labelSmall?.copyWith(color: ChibreColors.brass),
          ),
        ),
      ],
    );
  }
}
