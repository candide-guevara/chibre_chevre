import 'package:flutter/widgets.dart';

import 'card_design.dart';
import 'dark_deco/dark_deco.dart';

/// The card designs players can get; the first is the default.
const List<CardDesign> cardDesigns = [DarkDeco()];

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
