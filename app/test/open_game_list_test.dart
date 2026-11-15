import 'package:chibre/strings.dart';
import 'package:chibre/widgets/open_game_list.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a game of another protocol version shows both versions and '
      'cannot be joined', (tester) async {
    final joined = <OpenGame>[];
    final oldVersion = currentProtocolVersion - 1;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OpenGameList(
            games: [
              OpenGame(
                listing: GameListing(
                  gameId: 'old',
                  name: 'Partie de Ana',
                  hostNickname: 'Ana',
                  protocolVersion: oldVersion,
                ),
                address: 'old:1',
              ),
            ],
            installationId: 'me',
            onJoin: joined.add,
          ),
        ),
      ),
    );

    expect(
      find.text(Strings.versionDiffers(currentProtocolVersion, oldVersion)),
      findsOneWidget,
    );
    await tester.tap(find.text('Partie de Ana'));
    expect(joined, isEmpty);
  });
}
