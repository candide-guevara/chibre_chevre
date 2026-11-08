import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/foundation.dart';

import 'card_design.dart';

/// The faces of a deck, as bitmaps once they are loaded (see
/// `CardImageLoader`).
class CardImages extends ChangeNotifier {
  CardImages(this.design);

  /// The deck shared by every card of [design] on screen.
  factory CardImages.of(CardDesign design) =>
      _decks.putIfAbsent(design.id, () => CardImages(design));

  static final _decks = <String, CardImages>{};

  final CardDesign design;
  final _images = <Card, Image>{};

  Image? image(Card card) => _images[card];

  bool get isComplete => _images.length == Card.count;

  void add(Card card, Image image) {
    _images[card]?.dispose();
    _images[card] = image;
    notifyListeners();
  }
}
