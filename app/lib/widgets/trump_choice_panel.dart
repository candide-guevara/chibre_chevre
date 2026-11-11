import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme/chibre_theme.dart';
import 'suit_icon.dart';

/// The choices of the player who must make trump, filling the height it
/// is given; the [suggested] one, if any, is outlined.
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

  /// The height of a mode's symbol, as a share of its button's height.
  static const _symbolShare = 0.7;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // Buttons fill their row, however tall the panel is.
    const size = Size.zero, tapTarget = MaterialTapTargetSize.shrinkWrap;
    return Column(
      children: [
        // All the modes share one row, Obenabe and Undenufe drawn as arrows.
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              for (final mode in modes)
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: size,
                      tapTargetSize: tapTarget,
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
                      label: Strings.modeName(mode),
                      excludeSemantics: true,
                      child: _symbol(mode, text),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Kept empty once chibré, so the buttons keep their height.
        Expanded(
          child: canChibrer
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: size,
                        tapTargetSize: tapTarget,
                        side: suggested is Chibrer ? _outline : null,
                      ),
                      onPressed: onChibrer,
                      child: const Text(Strings.chibrer),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  /// The suit, or the arrow of Obenabe / Undenufe, sized to its button.
  Widget _symbol(TrumpMode mode, TextTheme text) => FractionallySizedBox(
    heightFactor: _symbolShare,
    child: FittedBox(
      child: mode.trumpSuit == null
          ? Text(Strings.modeSymbol(mode), style: text.titleLarge)
          : SuitIcon(mode.trumpSuit!, size: 26),
    ),
  );
}
