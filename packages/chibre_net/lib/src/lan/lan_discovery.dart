import 'dart:async';
import 'dart:io';

import '../codec/listing_codec.dart';
import '../proto/chibre.pb.dart' as pb;
import '../transport/open_game.dart';

/// Listens to the adverts broadcast by [LanAdvertisement]s. A game is
/// dropped when no advert was heard from it for [expiry].
class LanDiscovery {
  LanDiscovery({required this.port, required this.expiry});

  final int port;
  final Duration expiry;

  Stream<List<OpenGame>> watch() {
    final games = <String, _Heard>{};
    RawDatagramSocket? socket;
    Timer? cleaner;
    late final StreamController<List<OpenGame>> controller;

    void emit() =>
        controller.add([for (final heard in games.values) heard.game]);

    void receive(Datagram datagram) {
      final pb.GameAdvert advert;
      try {
        advert = pb.GameAdvert.fromBuffer(datagram.data);
      } on Exception {
        return;
      }
      if (advert.protocolVersion !=
          pb.ProtocolVersion.PROTOCOL_VERSION_CURRENT.value) {
        return;
      }
      final previous = games[advert.gameId];
      games[advert.gameId] = _Heard(
        OpenGame(
          listing: decodeListing(advert),
          address: '${datagram.address.address}:${advert.port}',
        ),
        advert,
        DateTime.now(),
      );
      if (previous == null || previous.advert != advert) emit();
    }

    controller = StreamController(
      onListen: () async {
        controller.add(const []);
        socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port,
            reuseAddress: true, reusePort: true);
        socket!.listen((event) {
          if (event != RawSocketEvent.read) return;
          final datagram = socket!.receive();
          if (datagram != null) receive(datagram);
        });
        cleaner = Timer.periodic(expiry ~/ 2, (_) {
          final limit = DateTime.now().subtract(expiry);
          final before = games.length;
          games.removeWhere((_, heard) => heard.time.isBefore(limit));
          if (games.length != before) emit();
        });
      },
      onCancel: () {
        cleaner?.cancel();
        socket?.close();
      },
    );
    return controller.stream;
  }
}

class _Heard {
  _Heard(this.game, this.advert, this.time);

  final OpenGame game;
  final pb.GameAdvert advert;
  final DateTime time;
}
