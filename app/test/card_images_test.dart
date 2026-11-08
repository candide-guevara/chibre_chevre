import 'package:chibre/card_art/card_designs.dart';
import 'package:chibre/card_art/card_image_loader.dart';
import 'package:chibre/card_art/card_images.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// An app bundle shipping no images.
class _EmptyBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async =>
      const StandardMessageCodec().encodeMessage(<String, Object>{})!;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final design in cardDesigns) {
    test('${design.name} ships all its cards', () async {
      final deck = CardImages(design);
      await CardImageLoader(rootBundle).load(deck, 40);
      expect(deck.isComplete, isTrue);
      final jack = deck.image(Card.parse('HJ'))!;
      expect(jack.width, 40, reason: 'scaled to the requested width');
      expect(jack.height, 60);
    });
  }

  test('reports the cards it has no image for', () async {
    final deck = CardImages(cardDesigns.first);
    await expectLater(
      CardImageLoader(_EmptyBundle()).load(deck, 40),
      throwsStateError,
    );
    expect(deck.isComplete, isFalse);
  });
}
