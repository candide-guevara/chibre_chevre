import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import '../labels.dart';
import '../theme/chibre_theme.dart';
import 'suit_icon.dart';

/// The choices of the player who must make trump; the [suggested] one, if
/// any, is outlined.
class TrumpChoicePanel extends StatelessWidget {
  const TrumpChoicePanel({
    super.key,
    required this.modes,
    required this.canChibrer,
    required this.onChoose,
    required this.onChibrer,
    this.suggested,
  });

  final List<TrumpMode> modes;
  final bool canChibrer;
  final void Function(TrumpMode mode) onChoose;
  final VoidCallback onChibrer;

  /// [ChooseTrump] or [Chibrer] suggested by the computer player.
  final GameAction? suggested;

  static const _outline = BorderSide(color: UiColors.accent, width: 3);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // All the modes share one row, Obenabe and Undenufe drawn as arrows.
        Row(
          spacing: 8,
          children: [
            for (final mode in modes)
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: switch (suggested) {
                      ChooseTrump(mode: final suggestedMode)
                          when suggestedMode == mode =>
                        _outline,
                      _ => null,
                    },
                  ),
                  onPressed: () => onChoose(mode),
                  child: Semantics(
                    label: modeName(mode),
                    excludeSemantics: true,
                    child: mode.trumpSuit == null
                        ? Text(modeSymbol(mode), style: text.titleLarge)
                        : SuitIcon(mode.trumpSuit!, size: 26),
                  ),
                ),
              ),
          ],
        ),
        if (canChibrer) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(64, 48),
              side: suggested is Chibrer ? _outline : null,
            ),
            onPressed: onChibrer,
            child: const Text('Chibrer'),
          ),
        ],
      ],
    );
  }
}
