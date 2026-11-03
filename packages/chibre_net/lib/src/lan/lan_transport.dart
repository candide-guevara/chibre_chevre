import 'dart:io';

import '../transport/advertisement.dart';
import '../transport/connection.dart';
import '../transport/game_listing.dart';
import '../transport/game_server.dart';
import '../transport/open_game.dart';
import '../transport/transport.dart';
import 'lan_advertisement.dart';
import 'lan_connection.dart';
import 'lan_discovery.dart';
import 'lan_server.dart';

/// Plays over the local network: games are advertised with UDP broadcasts
/// and played over TCP. No server or internet access needed.
class LanTransport implements Transport {
  LanTransport({
    this.discoveryPort = defaultDiscoveryPort,
    this.advertInterval = const Duration(seconds: 1),
  });

  static const defaultDiscoveryPort = 47820;

  final int discoveryPort;
  final Duration advertInterval;

  @override
  Future<GameServer> listen() => LanServer.bind();

  @override
  Future<Advertisement> advertise(GameServer server, GameListing listing) =>
      LanAdvertisement.start(
        port: (server as LanServer).port,
        discoveryPort: discoveryPort,
        listing: listing,
        interval: advertInterval,
      );

  @override
  Stream<List<OpenGame>> discover() =>
      LanDiscovery(port: discoveryPort, expiry: advertInterval * 3.5).watch();

  /// [game]'s address is `host:port`.
  @override
  Future<Connection> connect(OpenGame game) async {
    final separator = game.address.lastIndexOf(':');
    final host = game.address.substring(0, separator);
    final port = int.parse(game.address.substring(separator + 1));
    final socket =
        await Socket.connect(host, port, timeout: const Duration(seconds: 5));
    return LanConnection(socket);
  }
}
