import 'dart:io';

import '../transport/connection.dart';
import '../transport/game_server.dart';
import 'lan_connection.dart';

/// Accepts joiners on a TCP port picked by the system.
class LanServer implements GameServer {
  LanServer._(this._socket, this._ip);

  static Future<LanServer> bind() async {
    final socket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
    return LanServer._(socket, await _localIp());
  }

  final ServerSocket _socket;
  final String _ip;

  int get port => _socket.port;

  /// `ip:port` on the local network, e.g. for a manual join in debug builds.
  @override
  String get address => '$_ip:$port';

  @override
  Stream<Connection> get connections => _socket.map(LanConnection.new);

  @override
  Future<void> close() => _socket.close();

  static Future<String> _localIp() async {
    final interfaces =
        await NetworkInterface.list(type: InternetAddressType.IPv4);
    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        if (!address.isLoopback) return address.address;
      }
    }
    return InternetAddress.loopbackIPv4.address;
  }
}
