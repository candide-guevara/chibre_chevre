import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../codec/listing_codec.dart';
import '../transport/advertisement.dart';
import '../transport/game_listing.dart';

/// Broadcasts the listing of a hosted game on the local network every
/// [interval], as a UDP datagram holding a `GameAdvert`.
class LanAdvertisement implements Advertisement {
  LanAdvertisement._(this._socket, this._port, this._discoveryPort,
      GameListing listing, Duration interval) {
    update(listing);
    _timer = Timer.periodic(interval, (_) => _send());
  }

  static Future<LanAdvertisement> start({
    required int port,
    required int discoveryPort,
    required GameListing listing,
    required Duration interval,
  }) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
      ..broadcastEnabled = true;
    return LanAdvertisement._(socket, port, discoveryPort, listing, interval);
  }

  /// Other phones on the Wi-Fi, and other instances on this machine.
  static final _destinations = [
    InternetAddress('255.255.255.255'),
    InternetAddress.loopbackIPv4,
  ];

  final RawDatagramSocket _socket;
  final int _port;
  final int _discoveryPort;
  late Timer _timer;
  late Uint8List _datagram;

  @override
  void update(GameListing listing) {
    _datagram = encodeListing(listing, port: _port).writeToBuffer();
    _send();
  }

  @override
  Future<void> stop() async {
    _timer.cancel();
    _socket.close();
  }

  void _send() {
    for (final destination in _destinations) {
      try {
        _socket.send(_datagram, destination, _discoveryPort);
      } on SocketException {
        // No network right now; the next tick tries again.
      }
    }
  }
}
