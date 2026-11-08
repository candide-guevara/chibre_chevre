import 'dart:io';
import 'dart:ui';

import 'package:chibre/card_art/card_design.dart';
import 'package:chibre/card_art/card_designs.dart';
import 'package:chibre/card_art/card_image_loader.dart';
import 'package:chibre/card_art/card_image_sources.dart';
import 'package:chibre/card_art/card_images.dart';
import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _width = 40;

/// Renders the cards and counts them.
class _CountingRenderer implements CardImageSource {
  final rendered = <Card>[];

  @override
  Future<Image?> load(CardDesign design, Card card, int width) {
    rendered.add(card);
    return const CardRenderer().load(design, card, width);
  }
}

/// An app bundle holding [assets], each a small PNG.
class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this.assets);

  final List<String> assets;

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      return const StandardMessageCodec().encodeMessage({
        for (final asset in assets)
          asset: [
            {'asset': asset},
          ],
      })!;
    }
    final image = await const CardRenderer().load(
      cardDesigns.first,
      Card.fromIndex(0),
      8,
    );
    return (await image.toByteData(format: ImageByteFormat.png))!;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final design = cardDesigns.first;
  late Directory directory;

  setUp(() => directory = Directory.systemTemp.createTempSync('card-images'));
  tearDown(() => directory.deleteSync(recursive: true));

  test('renders every card once, then loads them from storage', () async {
    final renderer = _CountingRenderer();
    final first = CardImages(design);
    await CardImageLoader(
      store: CardImageStore(directory),
      renderer: renderer,
    ).load(first, _width);
    expect(first.isComplete, isTrue);
    expect(renderer.rendered, hasLength(Card.count));
    expect(first.image(Card.fromIndex(0))!.width, _width);

    final again = _CountingRenderer();
    final second = CardImages(design);
    await CardImageLoader(
      store: CardImageStore(directory),
      renderer: again,
    ).load(second, _width);
    expect(second.isComplete, isTrue);
    expect(again.rendered, isEmpty);
    expect(second.image(Card.fromIndex(0))!.height, _width * 3 ~/ 2);
  });

  test('prefers the images shipped in the app', () async {
    final jack = Card.parse('HJ');
    final renderer = _CountingRenderer();
    final deck = CardImages(design);
    await CardImageLoader(
      bundle: BundledCardImages(
        _FakeBundle(['assets/cards/${design.id}/$jack.png']),
      ),
      store: CardImageStore(directory),
      renderer: renderer,
    ).load(deck, _width);
    expect(deck.isComplete, isTrue);
    expect(deck.image(jack)!.width, _width);
    expect(renderer.rendered, hasLength(Card.count - 1));
    expect(renderer.rendered, isNot(contains(jack)));
  });

  test('deletes the images of other versions and widths', () async {
    final stale = [
      Directory('${directory.path}/${design.id}-v0-$_width'),
      Directory('${directory.path}/${design.id}-v${design.version}-90'),
    ];
    final other = Directory('${directory.path}/other-v1-$_width');
    for (final folder in [...stale, other]) {
      folder.createSync();
    }
    await CardImageLoader(store: CardImageStore(directory))
        .load(CardImages(design), _width);
    for (final folder in stale) {
      expect(folder.existsSync(), isFalse);
    }
    expect(other.existsSync(), isTrue);
    expect(
      Directory('${directory.path}/${design.id}-v${design.version}-$_width')
          .listSync()
          .where((f) => f.path.endsWith('.png')),
      hasLength(Card.count),
    );
  });
}
