import 'package:chibre_core/chibre_core.dart';

import 'card_image_sources.dart';
import 'card_images.dart';

/// Fills [CardImages] with bitmaps, card by card: from the app bundle when it
/// ships them, else from the phone's storage, else rendered and stored for
/// the next start.
class CardImageLoader {
  CardImageLoader({
    this.bundle,
    this.store,
    this.renderer = const CardRenderer(),
  });

  final CardImageSource? bundle;
  final CardImageStore? store;
  final CardImageSource renderer;

  /// Loads every card of [deck], [width] pixels wide.
  Future<void> load(CardImages deck, int width) async {
    final design = deck.design;
    await store?.deleteStale(design, width);
    for (final card in Card.all) {
      final known =
          await bundle?.load(design, card, width) ??
          await store?.load(design, card, width);
      if (known != null) {
        deck.add(card, known);
        continue;
      }
      final rendered = await renderer.load(design, card, width);
      if (rendered == null) continue;
      deck.add(card, rendered);
      await store?.save(design, card, width, rendered);
    }
  }
}
