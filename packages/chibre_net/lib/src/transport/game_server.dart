import 'connection.dart';

/// Accepts the connections of phones joining a hosted game.
abstract interface class GameServer {
  Stream<Connection> get connections;

  /// Where joiners connect to, in a form the transport understands.
  String get address;

  Future<void> close();
}
