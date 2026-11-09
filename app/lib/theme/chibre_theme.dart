import 'package:flutter/material.dart';

import '../widgets/back_arrow.dart';
import 'flow_color.dart';
import 'screen_theme.dart';

/// A sober palette derived from billiard table green.
abstract final class ChibreColors {
  static const felt = Color(0xFF0B6B3A);
  static const feltDark = Color(0xFF07482A);
  static const feltLight = Color(0xFF17844C);
  static const ivory = Color(0xFFFFFBF0);
  static const brass = Color(0xFFD9B95B);
  static const red = Color(0xFFC0272D);
  static const ink = Color(0xFF1E2623);
  static const slate = Color(0xFF2F4555);

  /// The cards of the Art Deco "Ivoire" deck.
  static const cream = Color(0xFFF3E8CF);

  // Screen backgrounds, all of the same lightness (OKLab L 0.339).
  static const navy = Color(0xFF0E356F);
  static const pine = Color(0xFF164223);
  static const plum = Color(0xFF4F264A);
  static const olive = Color(0xFF363B13);
  static const rust = Color(0xFF562B00);
  static const crimson = Color(0xFF6D0408);
}

/// What each element of the interface is painted with. Widgets only use
/// these roles, so that restyling an element is a change here.
abstract final class UiColors {
  static const text = ChibreColors.ivory;
  static final textMuted = text.withValues(alpha: 0.7);

  /// Whose turn it is, selections, suggestions, points gained, multiplier.
  static const accent = ChibreColors.brass;

  /// Text on [accent].
  static const onAccent = ChibreColors.feltDark;

  /// The app bar, and the score board atop the table.
  static const topBar = ChibreColors.slate;

  /// The pop-ups on the table: melds, Stöck, round summary.
  static const popup = ChibreColors.slate;

  /// Boxes on a screen: blunders, paused games in the list.
  static const panel = ChibreColors.feltDark;

  /// The players' names around the table, when it is not their turn.
  static const seatBadge = ChibreColors.feltDark;

  /// Covers the table while the game is paused.
  static final pauseOverlay = ChibreColors.feltDark.withValues(alpha: 0.8);

  /// Filled buttons' background, outlined buttons' text and border; filled
  /// buttons write in the background of their screen (see [ScreenTheme]).
  static const button = ChibreColors.cream;

  static const trumpBadge = ChibreColors.ivory;
  static const onTrumpBadge = ChibreColors.feltDark;

  /// Behind the cards written as text, e.g. "7♣".
  static const cardLabel = ChibreColors.ivory;

  /// Outline of the card designs not chosen.
  static final faintOutline = text.withValues(alpha: 0.2);

  /// Suits drawn outside the cards.
  static const redSuit = ChibreColors.red;
  static const blackSuit = ChibreColors.ink;
}

/// The backgrounds of the screens. The start screen, the table and the
/// insights have their own; the others take the color of the way the player
/// got there from the start screen (see [FlowColor]).
abstract final class ScreenColors {
  static const start = ChibreColors.navy;
  static const play = ChibreColors.pine;
  static const insights = ChibreColors.navy;

  static const profile = ChibreColors.plum;
  static const network = ChibreColors.olive;
  static const solo = ChibreColors.rust;
  static const resumed = ChibreColors.crimson;
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
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => const BackArrow(),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: UiColors.topBar,
      foregroundColor: UiColors.text,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(240, 52),
        backgroundColor: UiColors.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(240, 52),
        foregroundColor: UiColors.button,
        side: const BorderSide(color: UiColors.button),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 18),
      ),
    ),
    // Text fields show the screen's background.
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
