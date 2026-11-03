import 'package:flutter/widgets.dart';

import '../card_art/card_back_painter.dart';
import 'playing_card.dart';

class CardBack extends StatelessWidget {
  const CardBack({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(width, width * cardAspectRatio),
    painter: const CardBackPainter(),
  );
}
