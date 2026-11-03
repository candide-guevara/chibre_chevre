import 'dart:io';
import 'dart:typed_data';

import 'saved_game_store.dart';

/// Keeps the saved game in a single file. Writes are queued so a slow write
/// is never overtaken by an older one.
class FileSavedGameStore implements SavedGameStore {
  FileSavedGameStore(this.file);

  final File file;
  Future<void> _pending = Future.value();

  @override
  Future<Uint8List?> load() async {
    await _pending;
    return await file.exists() ? file.readAsBytes() : null;
  }

  @override
  Future<void> save(Uint8List savedGame) => _queue(() async {
        final temporary = File('${file.path}.tmp');
        await temporary.writeAsBytes(savedGame, flush: true);
        await temporary.rename(file.path);
      });

  @override
  Future<void> clear() => _queue(() async {
        if (await file.exists()) await file.delete();
      });

  Future<void> _queue(Future<void> Function() write) =>
      _pending = _pending.then((_) => write());
}
