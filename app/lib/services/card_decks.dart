import 'package:flutter/foundation.dart';

import '../card_art/card_design.dart';
import '../card_art/card_designs.dart';
import '../card_art/card_image_loader.dart';
import '../card_art/card_images.dart';
import 'profile_store.dart';

/// The card design chosen on this phone, and the loading of card images in
/// the background, once per design.
class CardDecks extends ValueNotifier<CardDesign> {
  CardDecks(this._profile, {this.loader, this.pixelWidth = 0})
    : super(cardDesignById(_profile.cardDesign)) {
    load(value);
  }

  final ProfileStore _profile;

  /// Without a loader, as in widget tests, cards stay blank.
  final CardImageLoader? loader;

  /// The width of the largest cards on this screen, in pixels.
  final int pixelWidth;

  final _loading = <String, Future<void>>{};

  /// Loads the images of [design], if not done yet. A failed load is
  /// reported and tried again on the next call.
  Future<void> load(CardDesign design) => _loading.putIfAbsent(
    design.id,
    () =>
        loader?.load(CardImages.of(design), pixelWidth).onError((error, stack) {
          _loading.remove(design.id);
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error!,
              stack: stack,
              library: 'card images',
            ),
          );
        }) ??
        Future.value(),
  );

  Future<void> choose(CardDesign design) async {
    value = design;
    load(design);
    await _profile.setCardDesign(design.id);
  }
}
