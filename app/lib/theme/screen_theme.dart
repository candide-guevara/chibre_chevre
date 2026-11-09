import 'package:flutter/material.dart';

/// The theme of a screen, or pop-up, with the background [color]: filled
/// buttons write in that color.
class ScreenTheme extends StatelessWidget {
  const ScreenTheme({super.key, required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Only its colors: the rest of the style would bring Flutter's defaults,
    // e.g. a smaller text.
    final colors = FilledButton.styleFrom(foregroundColor: color);
    return Theme(
      data: theme.copyWith(
        scaffoldBackgroundColor: color,
        filledButtonTheme: FilledButtonThemeData(
          style: theme.filledButtonTheme.style!.copyWith(
            foregroundColor: colors.foregroundColor,
            iconColor: colors.iconColor,
          ),
        ),
      ),
      child: child,
    );
  }
}
