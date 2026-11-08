import 'package:flutter/widgets.dart';

import 'card_design.dart';

/// The card designs players can choose from; the first is the default.
const List<CardDesign> cardDesigns = [
  CardDesign(
    id: 'vintage',
    name: 'Vintage',
    cornerRadius: 0.07,
    blank: Color(0xFFFBE6C4),
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
