import 'dart:io';
import 'dart:ui' as ui;

import 'package:chibre/card_art/card_designs.dart';
import 'package:chibre/widgets/playing_card.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Set CARD_SHEET_DIR to also save a picture of every card, to review the art.
const _sheetDirectory = String.fromEnvironment('CARD_SHEET_DIR');

void main() {
  for (final design in cardDesigns) {
    testWidgets('paints all ${design.name} cards', (tester) async {
      final boundary = GlobalKey();
      tester.view.physicalSize = const Size(9 * 92, 4 * 137);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CardDesignScope(
            design: design,
            child: RepaintBoundary(
              key: boundary,
              child: ColoredBox(
                color: const Color(0xFF0B6B3A),
                child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: [
                    for (final card in Card.all)
                      PlayingCard(card: card, width: 90),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      if (_sheetDirectory.isEmpty) return;
      await tester.runAsync(() async {
        final render =
            boundary.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = await render.toImage();
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File('$_sheetDirectory/${design.id}.png')
            .writeAsBytesSync(png!.buffer.asUint8List());
      });
    });
  }
}
