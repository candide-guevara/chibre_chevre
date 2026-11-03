import 'package:flutter/material.dart';

/// A sober palette derived from billiard table green.
abstract final class ChibreColors {
  static const felt = Color(0xFF0B6B3A);
  static const feltDark = Color(0xFF07482A);
  static const feltLight = Color(0xFF17844C);
  static const ivory = Color(0xFFFFFBF0);
  static const brass = Color(0xFFD9B95B);
  static const red = Color(0xFFC0272D);
  static const ink = Color(0xFF1E2623);
}

ThemeData chibreTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: ChibreColors.felt,
    brightness: Brightness.dark,
    primary: ChibreColors.ivory,
    onPrimary: ChibreColors.feltDark,
    secondary: ChibreColors.brass,
    surface: ChibreColors.feltDark,
    onSurface: ChibreColors.ivory,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: ChibreColors.felt,
    appBarTheme: const AppBarTheme(
      backgroundColor: ChibreColors.feltDark,
      foregroundColor: ChibreColors.ivory,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(240, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(240, 52),
        foregroundColor: ChibreColors.ivory,
        side: const BorderSide(color: ChibreColors.ivory),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 18),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: ChibreColors.feltDark,
    ),
  );
}
