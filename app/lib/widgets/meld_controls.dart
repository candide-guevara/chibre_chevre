import 'package:flutter/material.dart';

import '../strings.dart';

/// The single button of the meld choice at the start of a round: play
/// without announcing while no card is selected, or announce the selected
/// cards.
class MeldControls extends StatelessWidget {
  const MeldControls({
    super.key,
    required this.hasSelection,
    required this.onSkip,
    required this.onValidate,
  });

  final bool hasSelection;
  final VoidCallback onSkip;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    const size = Size(200, 44);
    return hasSelection
        ? FilledButton(
            style: FilledButton.styleFrom(minimumSize: size),
            onPressed: onValidate,
            child: const Text(Strings.validateMelds),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: size),
            onPressed: onSkip,
            child: const Text(Strings.skipMelds),
          );
  }
}
