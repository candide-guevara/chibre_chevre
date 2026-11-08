import 'dart:io';
import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/services.dart';

import 'card_design.dart';
import 'card_images.dart';

/// Somewhere card bitmaps [width] pixels wide can come from.
abstract interface class CardImageSource {
  /// The image of [card], or null when this source has none.
  Future<Image?> load(CardDesign design, Card card, int width);
}

int _height(int width) =>
    (width * cardDesignSize.height / cardDesignSize.width).round();

String _fileName(Card card) => '$card.png';

Future<Image> _decode(Uint8List bytes, int width) async {
  final codec = await instantiateImageCodec(
    bytes,
    targetWidth: width,
    targetHeight: _height(width),
  );
  final frame = await codec.getNextFrame();
  codec.dispose();
  return frame.image;
}

/// Draws the cards from their vector art.
class CardRenderer implements CardImageSource {
  const CardRenderer();

  @override
  Future<Image> load(CardDesign design, Card card, int width) {
    final picture = recordCard(design, card, width / cardDesignSize.width);
    return picture.toImage(width, _height(width)).whenComplete(picture.dispose);
  }
}

/// Images shipped in the app, at `<root>/<design id>/<card>.png`, e.g.
/// `assets/cards/dark_deco/HJ.png`. They are scaled to the requested width.
class BundledCardImages implements CardImageSource {
  BundledCardImages(this.bundle, {this.root = 'assets/cards'});

  final AssetBundle bundle;
  final String root;
  late final Future<Set<String>> _assets = AssetManifest.loadFromAssetBundle(
    bundle,
  ).then((manifest) => manifest.listAssets().toSet());

  @override
  Future<Image?> load(CardDesign design, Card card, int width) async {
    final key = '$root/${design.id}/${_fileName(card)}';
    if (!(await _assets).contains(key)) return null;
    final data = await bundle.load(key);
    return _decode(data.buffer.asUint8List(), width);
  }
}

/// Images rendered on this phone, saved in [directory] so that they are only
/// rendered once per design version and width.
class CardImageStore implements CardImageSource {
  CardImageStore(this.directory);

  final Directory directory;

  Directory _folder(CardDesign design, int width) =>
      Directory('${directory.path}/${design.id}-v${design.version}-$width');

  File _file(CardDesign design, Card card, int width) =>
      File('${_folder(design, width).path}/${_fileName(card)}');

  @override
  Future<Image?> load(CardDesign design, Card card, int width) async {
    final file = _file(design, card, width);
    try {
      return await _decode(await file.readAsBytes(), width);
    } on Exception {
      return null;
    }
  }

  Future<void> save(
    CardDesign design,
    Card card,
    int width,
    Image image,
  ) async {
    final png = await image.toByteData(format: ImageByteFormat.png);
    if (png == null) return;
    final file = _file(design, card, width);
    await file.parent.create(recursive: true);
    // Written aside then renamed, so that an interrupted save leaves no
    // broken image behind.
    final partial = File('${file.path}.$pid.part');
    await partial.writeAsBytes(png.buffer.asUint8List(), flush: true);
    await partial.rename(file.path);
  }

  /// Deletes the images of older versions or other widths of [design].
  Future<void> deleteStale(CardDesign design, int width) async {
    if (!await directory.exists()) return;
    final current = _folder(design, width).path;
    await for (final entry in directory.list()) {
      final name = entry.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
      if (entry is Directory &&
          entry.path != current &&
          name.startsWith('${design.id}-v')) {
        await entry.delete(recursive: true);
      }
    }
  }
}
