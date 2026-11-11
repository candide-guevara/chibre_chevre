import 'package:flutter/material.dart';

/// The buttons at the bottom of the play screen, as tall as their parent
/// lets them.
class GameActionsBar extends StatelessWidget {
  const GameActionsBar({
    super.key,
    required this.onPlayForMe,
    required this.thinking,
    required this.onPlayedCards,
  });

  /// Null when it is not the player's turn.
  final VoidCallback? onPlayForMe;

  /// The computer player is choosing the move.
  final bool thinking;
  final VoidCallback onPlayedCards;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: OutlinedButton(
              style: style,
              onPressed: thinking ? null : onPlayForMe,
              child: thinking
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Jouer pour moi'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              style: style,
              onPressed: onPlayedCards,
              child: const Text('Cartes jouées'),
            ),
          ),
        ],
      ),
    );
  }
}
