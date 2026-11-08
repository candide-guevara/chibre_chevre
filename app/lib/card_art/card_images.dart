import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/foundation.dart';

import 'card_design.dart';

/// Records [card] in [design], scaled from the 400×600 design box by [scale].
Picture recordCard(CardDesign design, Card card, [double scale = 1]) {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder)..scale(scale);
  design.paint(canvas, card);
  return recorder.endRecording();
}

/// The faces of a deck. Each card is a bitmap once one has been loaded (see
/// `CardImageLoader`), and a replayed vector drawing until then.
class CardImages extends ChangeNotifier {
  CardImages(this.design);

  /// The deck shared by every card of [design] on screen.
  factory CardImages.of(CardDesign design) =>
      _decks.putIfAbsent(design.id, () => CardImages(design));

  static final _decks = <String, CardImages>{};

  final CardDesign design;
  final _images = <Card, Image>{};
  final _pictures = <Card, Picture>{};

  Image? image(Card card) => _images[card];

  Picture picture(Card card) =>
      _pictures.putIfAbsent(card, () => recordCard(design, card));

  bool get isComplete => _images.length == Card.count;

  void add(Card card, Image image) {
    _images[card]?.dispose();
    _images[card] = image;
    _pictures.remove(card)?.dispose();
    notifyListeners();
  }
}
