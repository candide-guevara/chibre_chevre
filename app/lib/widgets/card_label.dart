import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart' hide Card;

import '../card_art/suit_symbol.dart';
import '../strings.dart';
import '../theme/chibre_theme.dart';
import 'suit_icon.dart';

/// A card written as its rank followed by its suit, e.g. "7♣", on an
/// ivory label so that black suits stay readable on the felt.
class CardLabel extends StatelessWidget {
  const CardLabel(this.card, {super.key});

  final Card card;

  static const _size = 15.0;

  @override
  Widget build(BuildContext context) => Semantics(
    label: Strings.cardName(card),
    excludeSemantics: true,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: UiColors.cardLabel,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Strings.rankIndex(card.rank),
            style: TextStyle(
              color: suitColor(card.suit),
              fontSize: _size,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(width: 1),
          SuitIcon(card.suit, size: _size * 0.8),
        ],
      ),
    ),
  );
}

/// [card] as a [CardLabel] within a text.
InlineSpan cardSpan(Card card) =>
    WidgetSpan(alignment: PlaceholderAlignment.middle, child: CardLabel(card));
