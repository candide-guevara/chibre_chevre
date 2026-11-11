import 'package:flutter/material.dart';

import '../strings.dart';

/// The buttons at the bottom of the host screen. The primary action
/// (starting the game, or saving the defaults) is the filled, brighter
/// button, so the eye goes to it first.
class HostActionsBar extends StatelessWidget {
  const HostActionsBar({
    super.key,
    required this.onDefaults,
    required this.onAdvanced,
    required this.primaryLabel,
    required this.onPrimary,
  });

  final VoidCallback onDefaults;
  final VoidCallback onAdvanced;

  final String primaryLabel;

  /// Null while the options are not valid.
  final VoidCallback? onPrimary;

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
                child: const Text(Strings.loadDefaults),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: OutlinedButton(
                style: outlined,
                onPressed: onAdvanced,
                child: const Text(Strings.advanced),
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
                onPressed: onPrimary,
                child: Text(primaryLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
