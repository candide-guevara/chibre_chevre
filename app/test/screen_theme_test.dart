import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre/theme/screen_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('filled buttons write in the color of the screen, at the same '
      'size', (tester) async {
    const color = ScreenColors.start;
    await tester.pumpWidget(
      MaterialApp(
        theme: chibreTheme(),
        home: ScreenTheme(
          color: color,
          child: Center(
            child: FilledButton(onPressed: () {}, child: const Text('Jouer')),
          ),
        ),
      ),
    );
    final style = tester
        .renderObject<RenderParagraph>(find.text('Jouer'))
        .text
        .style!;
    expect(style.fontSize, 18);
    expect(style.color, color);
  });
}
