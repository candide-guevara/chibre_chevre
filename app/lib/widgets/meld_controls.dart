import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import '../labels.dart';

/// Buttons to announce melds during the first trick: "Annoncer" switches the
/// hand to selection mode, "Valider" announces the selected cards.
class MeldControls extends StatelessWidget {
  const MeldControls({
    super.key,
    required this.selecting,
    required this.announced,
    required this.onStart,
    required this.onValidate,
    required this.onCancel,
  });

  final bool selecting;
  final List<Meld> announced;
  final VoidCallback onStart;
  final VoidCallback onValidate;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    const compact = Size(96, 40);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final meld in announced) Chip(label: Text(meldName(meld))),
        if (selecting) ...[
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: compact),
            onPressed: onValidate,
            child: const Text('Valider'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: compact),
            onPressed: onCancel,
            child: const Text('Annuler'),
          ),
        ] else
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: compact),
            onPressed: onStart,
            child: const Text('Annoncer'),
          ),
      ],
    );
  }
}
