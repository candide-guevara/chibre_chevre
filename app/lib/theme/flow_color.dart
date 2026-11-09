import 'package:flutter/material.dart';

import 'screen_theme.dart';
import 'chibre_theme.dart';

/// The background of the screens of one way through the app (profile,
/// network game, single player game, resumed game), chosen on the start
/// screen: the same screen has a different color depending on how the
/// player got there.
class FlowColor extends InheritedWidget {
  const FlowColor({super.key, required this.color, required super.child});

  final Color color;

  static Color of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FlowColor>()?.color ??
      ScreenColors.network;

  @override
  bool updateShouldNotify(FlowColor oldWidget) => color != oldWidget.color;
}

/// A route to [builder] that keeps the flow color of [context].
MaterialPageRoute<T> flowRoute<T>(BuildContext context, WidgetBuilder builder) {
  final color = FlowColor.of(context);
  return MaterialPageRoute<T>(
    builder: (context) => FlowColor(
      color: color,
      child: ScreenTheme(color: color, child: builder(context)),
    ),
  );
}
