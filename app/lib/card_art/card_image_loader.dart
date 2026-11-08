import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/services.dart';

import 'card_images.dart';

/// Loads the card images shipped in the app, at
/// `<root>/<design id>/<card>.<format>`, e.g. `assets/cards/vintage/HJ.webp`.
class CardImageLoader {
  CardImageLoader(this.bundle, {this.root = 'assets/cards'});

  final AssetBundle bundle;
  final String root;
  late final Future<List<String>> _assets = AssetManifest.loadFromAssetBundle(
    bundle,
  ).then((manifest) => manifest.listAssets());

  /// Loads every card of [deck], scaled to [width] pixels. Throws when some
  /// cards have no image.
  Future<void> load(CardImages deck, int width) async {
    final assets = await _assets;
    final missing = <Card>[];
    for (final card in Card.all) {
      final prefix = '$root/${deck.design.id}/$card.';
      final key = assets.where((a) => a.startsWith(prefix)).firstOrNull;
      if (key == null) {
        missing.add(card);
        continue;
      }
      final data = await bundle.load(key);
      deck.add(card, await _decode(data.buffer.asUint8List(), width));
    }
    if (missing.isNotEmpty) {
      throw StateError('No image for the ${deck.design.id} cards $missing');
    }
  }

  Future<Image> _decode(Uint8List bytes, int width) async {
    final codec = await instantiateImageCodec(bytes, targetWidth: width);
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }
}
