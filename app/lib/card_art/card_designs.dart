import 'package:flutter/widgets.dart';

import '../strings.dart';
import 'card_design.dart';

/// The card designs players can choose from; the first is the default.
const List<CardDesign> cardDesigns = [
  CardDesign(
    id: 'vintage',
    name: Strings.vintageCards,
    cornerRadius: 0.07,
    blank: Color(0xFFFBE6C4),
  ),
  CardDesign(
    id: 'ivory',
    name: Strings.ivoryCards,
    cornerRadius: 0.056,
    blank: Color(0xFFF3E8CF),
  ),
  CardDesign(
    id: 'midnight',
    name: Strings.midnightCards,
    cornerRadius: 0.056,
    blank: Color(0xFF0A377C),
  ),
];

/// The design with [id], or the default one.
CardDesign cardDesignById(String? id) =>
    cardDesigns.firstWhere((d) => d.id == id, orElse: () => cardDesigns.first);

/// Provides the card design to the cards below it.
class CardDesignScope extends InheritedWidget {
  const CardDesignScope({
    super.key,
    required this.design,
    required super.child,
  });

  final CardDesign design;

  /// The design of the closest scope, or the default one.
  static CardDesign of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CardDesignScope>()?.design ??
      cardDesigns.first;

  @override
  bool updateShouldNotify(CardDesignScope oldWidget) =>
      design != oldWidget.design;
}
