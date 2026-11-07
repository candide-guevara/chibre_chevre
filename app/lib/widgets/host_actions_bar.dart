import 'package:flutter/material.dart';

/// The buttons at the bottom of the host screen. Starting the game is the
/// filled, brighter button, so the eye goes to it first.
class HostActionsBar extends StatelessWidget {
  const HostActionsBar({
    super.key,
    required this.onDefaults,
    required this.onAdvanced,
    required this.onStart,
  });

  final VoidCallback onDefaults;
  final VoidCallback onAdvanced;

  /// Null while the game cannot start.
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    const size = Size(0, 52);
    const text = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
    final outlined = OutlinedButton.styleFrom(
      minimumSize: size,
      textStyle: text,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(
                style: outlined,
                onPressed: onDefaults,
                child: const Text('Par défaut'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: OutlinedButton(
                style: outlined,
                onPressed: onAdvanced,
                child: const Text('Avancé'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: size,
                  textStyle: text,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onPressed: onStart,
                child: const Text('Lancer la partie'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
