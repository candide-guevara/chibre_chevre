import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import '../labels.dart';

/// The choices of the player who must make trump.
class TrumpChoicePanel extends StatelessWidget {
  const TrumpChoicePanel({
    super.key,
    required this.modes,
    required this.canChibrer,
    required this.onChoose,
    required this.onChibrer,
  });

  final List<TrumpMode> modes;
  final bool canChibrer;
  final void Function(TrumpMode mode) onChoose;
  final VoidCallback onChibrer;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final mode in modes)
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(64, 48)),
          onPressed: () => onChoose(mode),
          child: Text(
            mode.trumpSuit == null ? modeName(mode) : modeSymbol(mode),
            semanticsLabel: modeName(mode),
          ),
        ),
      if (canChibrer)
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(64, 48)),
          onPressed: onChibrer,
          child: const Text('Chibrer'),
        ),
    ],
  );
}
