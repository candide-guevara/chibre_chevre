import 'dart:typed_data';

import 'package:chibre_net/chibre_net.dart';
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
}
