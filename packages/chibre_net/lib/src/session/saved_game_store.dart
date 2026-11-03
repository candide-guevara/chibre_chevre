import 'dart:typed_data';

/// Where the host keeps the game in progress, so it can resume after the app
/// was killed. The content is an encoded `SavedGame` message.
abstract interface class SavedGameStore {
  Future<Uint8List?> load();

  Future<void> save(Uint8List savedGame);

  Future<void> clear();
}
