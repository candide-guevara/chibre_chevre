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

  /// Loads every card of [deck], [width] pixels wide. Throws when some cards
  /// have no image, e.g. images missing from the app bundle.
  Future<void> load(CardImages deck, int width) async {
    final design = deck.design;
    await store?.deleteStale(design, width);
    final missing = <Card>[];
    for (final card in Card.all) {
      final known =
          await bundle?.load(design, card, width) ??
          await store?.load(design, card, width);
      if (known != null) {
        deck.add(card, known);
        continue;
      }
      final rendered = await renderer.load(design, card, width);
      if (rendered == null) {
        missing.add(card);
        continue;
      }
      deck.add(card, rendered);
      await store?.save(design, card, width, rendered);
    }

    if (missing.isNotEmpty) {
      throw StateError('No image for the ${design.id} cards $missing');
    }
  }
}
