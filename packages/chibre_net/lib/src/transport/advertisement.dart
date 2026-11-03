import 'game_listing.dart';

/// A hosted game being published to other phones.
abstract interface class Advertisement {
  /// Replaces the published information, e.g. when the game gets paused.
  void update(GameListing listing);

  Future<void> stop();
}
