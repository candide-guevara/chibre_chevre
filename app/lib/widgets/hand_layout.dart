import 'dart:math';

import 'playing_card.dart';

/// Where the cards of the hand go in a given width: they overlap, each
/// shifted by [step] from the previous one, so that all of them fit.
class HandLayout {
  HandLayout(double maxWidth, this.cardCount)
    : cardWidth = min(maxCardWidth, maxWidth / _cardsAcross) {
    step = cardCount <= 1
        ? 0.0
        : min(
            cardWidth * _maxStepInCards,
            (maxWidth - cardWidth) / (cardCount - 1),
          );
  }

  /// How many card widths fit across the hand at most.
  static const _cardsAcross = 4.2;

  /// The largest shift between two cards, in card widths.
  static const _maxStepInCards = 1.05;

  final int cardCount;
  final double cardWidth;
  late final double step;

  double get width => cardCount == 0 ? 0 : cardWidth + step * (cardCount - 1);

  double get cardHeight => cardWidth * cardAspectRatio;

  /// The room above the cards for the selected ones to rise.
  double get riseRoom =>
      cardCount == 0 ? 0 : cardHeight * PlayingCard.selectedRise;

  /// The height of the hand, rise room included.
  double get height => cardCount == 0 ? 0 : cardHeight + riseRoom;

  /// The visible part of a card: the last card shows whole, the others up
  /// to the next card.
  double columnWidth(int index) => index == cardCount - 1 ? cardWidth : step;
}
