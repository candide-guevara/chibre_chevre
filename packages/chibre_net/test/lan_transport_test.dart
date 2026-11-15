import 'dart:io';
import 'dart:typed_data';

import 'package:chibre_net/chibre_net.dart';
import 'package:chibre_net/src/proto/chibre.pb.dart' as pb;
import 'package:test/test.dart';

void main() {
  test('a game advertised on the LAN is discovered and joined', () async {
    final transport = LanTransport(
      discoveryPort: 47000 + DateTime.now().millisecond,
      advertInterval: const Duration(milliseconds: 100),
    );
    final server = await transport.listen();
    final discovered = transport
        .discover()
        .expand((games) => games)
        .firstWhere((game) => game.listing.gameId == 'lan-test');
    final advertisement = await transport.advertise(
        server,
        const GameListing(
            gameId: 'lan-test', name: 'Partie de Ana', hostNickname: 'Ana'));

    final game = await discovered.timeout(const Duration(seconds: 5));
    expect(game.listing.name, 'Partie de Ana');

    final hostSide = server.connections.first;
    final joinerSide = await transport.connect(game);
    final host = await hostSide;
    final received = host.messages.first;
    joinerSide.send(Uint8List.fromList([1, 2, 3]));
    expect(await received, [1, 2, 3]);

    final reply = joinerSide.messages.first;
    host.send(Uint8List.fromList([4]));
    expect(await reply, [4]);

    await joinerSide.close();
    await advertisement.stop();
    await server.close();
  });

  test('a game of another protocol version is listed but not joinable',
      () async {
    final port = 48000 + DateTime.now().millisecond;
    final transport = LanTransport(discoveryPort: port);
    final discovered = transport
        .discover()
        .expand((games) => games)
        .firstWhere((game) => game.listing.gameId == 'old-host');
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    final advert = pb.GameAdvert(
      protocolVersion: currentProtocolVersion - 1,
      gameId: 'old-host',
      name: 'Partie de Ana',
      hostNickname: 'Ana',
      port: 1,
    ).writeToBuffer();
    final sender = Stream.periodic(const Duration(milliseconds: 100))
        .listen((_) => socket.send(advert, InternetAddress.loopbackIPv4, port));

    final game = await discovered.timeout(const Duration(seconds: 5));
    expect(game.listing.protocolVersion, currentProtocolVersion - 1);
    expect(game.listing.isCompatible, isFalse);
    expect(game.listing.joinableBy('anyone'), isFalse);

    await sender.cancel();
    socket.close();
  });
}
