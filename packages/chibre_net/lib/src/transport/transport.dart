import 'advertisement.dart';
import 'connection.dart';
import 'game_server.dart';
import 'game_listing.dart';
import 'open_game.dart';

/// How phones find each other and exchange messages. The LAN implementation
/// is used today; an AWS backed one can be added later without touching the
/// sessions, the engine or the UI.
abstract interface class Transport {
  /// Starts accepting joiners for a hosted game.
  Future<GameServer> listen();

  /// Publishes [listing] so that [discover] lists it on other phones.
  Future<Advertisement> advertise(GameServer server, GameListing listing);

  /// The games currently published, updated as they appear and disappear.
  Stream<List<OpenGame>> discover();

  Future<Connection> connect(OpenGame game);
}
