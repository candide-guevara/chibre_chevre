import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:test/test.dart';

const budget =
    ComputeBudget(searchIterations: 30, trumpSamples: 5, analysisSamples: 3);
const options = GameOptions(targetScore: 300);

class MemoryStore implements SavedGameStore {
  Uint8List? saved;

  @override
  Future<Uint8List?> load() async => saved;

  @override
  Future<void> save(Uint8List savedGame) async => saved = savedGame;

  @override
  Future<void> clear() async => saved = null;
}

HostSession newHost(InMemoryNetwork network, {SavedGameStore? store}) =>
    HostSession(
      transport: InMemoryTransport(network),
      bots: InlineBotRunner(budget: budget, random: Random(1)),
      store: store,
      timing: SessionTiming.instant,
      random: Random(2),
    );

ClientSession newClient(InMemoryNetwork network, {String id = 'bea-phone'}) =>
    ClientSession(
      transport: InMemoryTransport(network),
      installationId: id,
      nickname: 'Bea',
      retryInterval: const Duration(milliseconds: 10),
    );

Future<OpenGame> findGame(InMemoryNetwork network,
        {bool Function(OpenGame)? where}) =>
    InMemoryTransport(network)
        .discover()
        .expand((games) => games)
        .firstWhere(where ?? (_) => true);

/// Plays for a human seat with the heuristic player whenever it's its turn.
StreamSubscription<TableView> autoplay(
    Stream<TableView> tables, void Function(GameAction) act) {
  final heuristic = HeuristicPlayer();
  return tables.listen((table) {
    if (table.isMyTurn) act(heuristic.decide(table.player!));
  });
}

Future<(HostSession, ClientSession)> startGame(InMemoryNetwork network,
    {SavedGameStore? store}) async {
  final host = newHost(network, store: store);
  await host.create(const HostConfig(
      gameName: 'Partie de Ana', nickname: 'Ana', options: options));
  final client = newClient(network);
  await client.join(await findGame(network));
  return (host, client);
}

void main() {
  test('a hosted game is listed until a player joins', () async {
    final network = InMemoryNetwork();
    final host = newHost(network);
    await host
        .create(const HostConfig(gameName: 'Partie de Ana', nickname: 'Ana'));
    expect(host.table!.phase, TablePhase.waitingForPlayer);

    final game = await findGame(network);
    expect(game.listing.name, 'Partie de Ana');
    expect(game.listing.isPaused, isFalse);

    final client = newClient(network);
    final firstTable = client.tables.first;
    await client.join(game);
    final table = await firstTable;
    expect(table.seat, 2);
    expect(table.nicknames, ['Ana', 'Ordi 1', 'Bea', 'Ordi 2']);
    expect(table.phase, isNot(TablePhase.waitingForPlayer));
    expect(await InMemoryTransport(network).discover().first, isEmpty);
    await host.close();
  });

  test('two humans and two bots play a whole game, then get insights',
      () async {
    final network = InMemoryNetwork();
    final (host, client) = await startGame(network);
    autoplay(host.tables, host.act);
    autoplay(client.tables, client.act);
    // Kick off in case the host must act first.
    if (host.table!.isMyTurn) {
      host.act(HeuristicPlayer().decide(host.table!.player!));
    }
    final hostEnd = await host.tables.firstWhere(
        (t) => t.phase == TablePhase.gameOver && t.insights != null);
    final clientEnd = client.table!.insights != null
        ? client.table!
        : await client.tables.firstWhere((t) => t.insights != null);
    expect(hostEnd.winningTeam, isNotNull);
    expect(clientEnd.scores, hostEnd.scores);
    expect(hostEnd.scores.reduce(max), greaterThanOrEqualTo(300));
    await host.close();
  });

  test('illegal actions of the joiner are rejected', () async {
    final network = InMemoryNetwork();
    final (host, client) = await startGame(network);
    final rejection = client.rejectedActions.first;
    client.act(const ChooseTrump(0, TrumpMode.hearts));
    expect(await rejection, isNotEmpty);
    await host.close();
  });

  test('a third phone cannot join', () async {
    final network = InMemoryNetwork();
    final host = newHost(network);
    await host.create(const HostConfig(gameName: 'g', nickname: 'Ana'));
    final game = await findGame(network);
    await newClient(network).join(game);
    expect(newClient(network, id: 'other').join(game),
        throwsA(isA<JoinRejectedException>()));
    await host.close();
  });

  test('a lost connection pauses the game until the joiner is back', () async {
    final network = InMemoryNetwork();
    final (host, client) = await startGame(network);
    final paused = host.tables.firstWhere((t) => t.isPaused);
    network.disconnectAll();
    expect((await paused).pausedFor, 'Bea');

    final listing = (await findGame(network)).listing;
    expect(listing.reservedFor, 'bea-phone');
    expect(listing.joinableBy('someone-else'), isFalse);

    await host.tables.firstWhere((t) => !t.isPaused);
    await client.tables.firstWhere((t) => !t.isPaused);
    await host.close();
  });

  test('a player in the background pauses the game', () async {
    final network = InMemoryNetwork();
    final (host, client) = await startGame(network);
    client.setAway(true);
    expect((await host.tables.firstWhere((t) => t.isPaused)).pausedFor, 'Bea');
    host.setAway(true);
    client.setAway(false);
    expect(
        (await client.tables.firstWhere((t) => t.pausedFor == 'Ana')).seat, 2);
    await host.close();
  });

  test('the joiner leaving ends the game for the host', () async {
    final network = InMemoryNetwork();
    final (host, client) = await startGame(network);
    final left = host.tables.firstWhere((t) => t.leftBy != null);
    await client.leave();
    expect((await left).leftBy, 'Bea');
    await host.close();
  });

  test('the host closing ends the game for the joiner', () async {
    final network = InMemoryNetwork();
    final (host, client) = await startGame(network);
    final left = client.tables.firstWhere((t) => t.leftBy != null);
    await host.close();
    expect((await left).leftBy, 'Ana');
  });

  test('a rematch with the same cards replays the same deal', () async {
    final network = InMemoryNetwork();
    final (host, client) = await startGame(network);
    final firstHand = host.table!.player!.hand;
    autoplay(host.tables, host.act);
    final clientPlay = autoplay(client.tables, client.act);
    if (host.table!.isMyTurn) {
      host.act(HeuristicPlayer().decide(host.table!.player!));
    }
    await host.tables.firstWhere((t) => t.phase == TablePhase.gameOver);
    await clientPlay.cancel();

    final offered = client.tables.firstWhere((t) => t.rematch != null);
    host.proposeRematch(sameCards: true);
    expect((await offered).rematch!.proposedBy, 0);
    final restarted =
        host.tables.firstWhere((t) => t.phase != TablePhase.gameOver);
    client.answerRematch(accept: true);
    final table = await restarted;
    expect(table.player!.hand, firstHand);
    expect(table.scores, [0, 0]);
    await host.close();
  });

  test('a restarted host resumes the saved game', () async {
    final network = InMemoryNetwork();
    final store = MemoryStore();
    final (host, client) = await startGame(network, store: store);
    final heuristic = HeuristicPlayer();
    final hostPlay = autoplay(host.tables, host.act);
    final clientPlay = autoplay(client.tables, client.act);
    if (host.table!.isMyTurn) host.act(heuristic.decide(host.table!.player!));
    final reached = await host.tables.firstWhere((t) => t.roundIndex == 1);
    await hostPlay.cancel();
    await clientPlay.cancel();
    expect(store.saved, isNotNull);
    expect(await HostSession.savedGameName(store), 'Partie de Ana');

    // The host app dies without closing anything.
    network.disconnectAll();
    final restarted = newHost(network, store: store);
    await restarted.resume();
    expect(restarted.table!.isPaused, isTrue);
    expect(restarted.table!.scores, reached.scores);

    final back = await restarted.tables.firstWhere((t) => !t.isPaused);
    expect(back.roundIndex, 1);
    await restarted.close();
    expect(store.saved, isNull);
  });
}
