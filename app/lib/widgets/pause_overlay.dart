import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme/chibre_theme.dart';

/// Covers the table while the game waits for a player to come back.
class PauseOverlay extends StatelessWidget {
  const PauseOverlay({
    super.key,
    required this.nickname,
    required this.onAbandon,
  });

  final String nickname;
  final VoidCallback onAbandon;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: UiColors.pauseOverlay,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: UiColors.text),
          const SizedBox(height: 16),
          Text(
            Strings.waitingFor(nickname),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onAbandon,
            child: const Text(Strings.abandon),
          ),
        ],
      ),
    ),
  );
}
