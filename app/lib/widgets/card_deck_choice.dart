import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart' hide Card;

import '../card_art/card_design.dart';
import '../card_art/card_designs.dart';
import '../theme/chibre_theme.dart';
import 'playing_card.dart';

/// The card designs side by side, each shown by a few of its cards, the
/// [selected] one outlined.
class CardDeckChoice extends StatelessWidget {
  const CardDeckChoice({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final CardDesign selected;
  final ValueChanged<CardDesign> onChanged;

  static final _samples = [
    for (final c in ['HK', 'SQ', 'DJ']) Card.parse(c),
  ];
  static const _cardWidth = 52.0;
  static const _step = 0.55;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [for (final design in cardDesigns) _option(context, design)],
  );

  Widget _option(BuildContext context, CardDesign design) {
    final isSelected = design.id == selected.id;
    return Semantics(
      label: design.name,
      button: true,
      selected: isSelected,
      excludeSemantics: true,
      child: InkWell(
        onTap: () => onChanged(design),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? ChibreColors.brass
                  : ChibreColors.ivory.withValues(alpha: 0.2),
              width: 3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CardDesignScope(
                design: design,
                child: SizedBox(
                  width: _cardWidth * (1 + _step * (_samples.length - 1)),
                  height: _cardWidth * cardAspectRatio,
                  child: Stack(
                    children: [
                      for (final (i, card) in _samples.indexed)
                        Positioned(
                          left: i * _cardWidth * _step,
                          child: PlayingCard(card: card, width: _cardWidth),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(design.name),
            ],
          ),
        ),
      ),
    );
  }
}
