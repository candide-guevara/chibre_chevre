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

/// Records the seats it decides for.
class RecordingBotRunner implements BotRunner {
  final _inner = InlineBotRunner(budget: budget, random: Random(1));
  final decidedFor = <int>[];

  @override
  Future<GameAction> decide(PlayerView view) {
    decidedFor.add(view.seat);
    return _inner.decide(view);
  }

  @override
  Future<Map<int, List<Blunder>>?> analyseRound(
          GameRecord record, int roundIndex,
          {Set<int> seats = const {0, 2}, Duration? timeLimit}) =>
      _inner.analyseRound(record, roundIndex,
          seats: seats, timeLimit: timeLimit);
}

/// Every round's analysis runs out of time until the game is over.
class TimingOutBotRunner implements BotRunner {
  final _inner = InlineBotRunner(budget: budget, random: Random(1));
  final timedOut = <int>[];
  final analysed = <int>[];

  @override
  Future<GameAction> decide(PlayerView view) => _inner.decide(view);

  @override
  Future<Map<int, List<Blunder>>?> analyseRound(
      GameRecord record, int roundIndex,
      {Set<int> seats = const {0, 2}, Duration? timeLimit}) async {
    if (timeLimit != null) {
      timedOut.add(roundIndex);
      return null;
    }
    analysed.add(roundIndex);
    return _inner.analyseRound(record, roundIndex, seats: seats);
  }
}

/// [thinkingTimes] records the thinking time of the computer players.
HostSession newHost(InMemoryNetwork network,
        {SavedGameStore? store,
        List<Duration>? thinkingTimes,
        BotRunner? bots}) =>
    HostSession(
      transport: InMemoryTransport(network),
      newBots: (thinkingTime) {
        thinkingTimes?.add(thinkingTime);
        return bots ?? InlineBotRunner(budget: budget, random: Random(1));
      },
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
StreamSubscription<TableView> autoplay(Stream<TableView> tables,
    void Function(GameAction) act, void Function() chooseMelds) {
  final heuristic = HeuristicPlayer();
  return tables.listen((table) {
    // Choosing melds publishes a new table, so this one is out of date.
    if (table.meldChoiceFor.contains(table.seat)) return chooseMelds();
    if (table.isMyTurn) act(heuristic.decide(table.player!));
  });
}

Future<(HostSession, ClientSession)> startGame(InMemoryNetwork network,
    {SavedGameStore? store, BotRunner? bots}) async {
  final host = newHost(network, store: store, bots: bots);
  await host.create(const HostConfig(
      gameName: 'Partie de Ana',
      nickname: 'Ana',
      options: options,
      trickHold: Duration.zero));
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
    autoplay(host.tables, host.act, host.meldsChosen);
    autoplay(client.tables, client.act, client.meldsChosen);
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

  test(
      'rounds analysed in the background, or not in time, end up in the '
      'insights', () async {
    final network = InMemoryNetwork();
    final bots = TimingOutBotRunner();
    final (host, client) = await startGame(network, bots: bots);
    autoplay(host.tables, host.act, host.meldsChosen);
    autoplay(client.tables, client.act, client.meldsChosen);
    if (host.table!.isMyTurn) {
      host.act(HeuristicPlayer().decide(host.table!.player!));
    }
    await host.tables.firstWhere((t) => t.insights != null);
    final rounds = bots.analysed.length;
    expect(rounds, greaterThan(1));
    expect(bots.timedOut, [for (var i = 0; i < rounds - 1; i++) i]);
    expect(bots.analysed..sort(), [for (var i = 0; i < rounds; i++) i]);
    await host.close();
  });

  test('the joiner and a resumed game use the host\'s settings', () async {
    final network = InMemoryNetwork();
    final store = MemoryStore();
    final thinkingTimes = <Duration>[];
    final host = newHost(network, store: store, thinkingTimes: thinkingTimes);
    await host.create(const HostConfig(
        gameName: 'g',
        nickname: 'Ana',
        trickHold: Duration(seconds: 3),
        assistance: true,
        sortByTrump: true,
        autoAnnounce: true,
        thinkingTime: Duration(milliseconds: 1400)));
    final client = newClient(network);
    await client.join(await findGame(network));
    final table = await client.tables.firstWhere((t) => t.player != null);
    expect(table.trickHold, const Duration(seconds: 3));
    expect(table.assistance, isTrue);
    expect(table.sortByTrump, isTrue);
    expect(table.autoAnnounce, isTrue);
    expect(table.thinkingTime, const Duration(milliseconds: 1400));

    network.disconnectAll();
    final restarted =
        newHost(network, store: store, thinkingTimes: thinkingTimes);
    await restarted.resume();
    expect(restarted.table!.trickHold, const Duration(seconds: 3));
    expect(restarted.table!.assistance, isTrue);
    expect(restarted.table!.sortByTrump, isTrue);
    expect(restarted.table!.autoAnnounce, isTrue);
    expect(restarted.table!.thinkingTime, const Duration(milliseconds: 1400));
    expect(thinkingTimes, List.filled(2, const Duration(milliseconds: 1400)));
    await restarted.close();
  });

  test('new games can be dealt from a given deal source', () async {
    final network = InMemoryNetwork();
    final preset = CardSet.parse('D7 D9 DJ DA');
    final host = HostSession(
      transport: InMemoryTransport(network),
      newBots: (_) => InlineBotRunner(budget: budget, random: Random(1)),
      timing: SessionTiming.instant,
      newDeals: (random) => PresetHandDealSource({0: preset}, random),
    );
    await host.create(const HostConfig(gameName: 'g', nickname: 'Ana'));
    await newClient(network).join(await findGame(network));
    await pumpEventQueue();
    expect(host.table!.player!.hand & preset, preset);
    await host.close();
  });

  test('the bots wait for both humans to choose their melds', () async {
    final network = InMemoryNetwork();
    final host = HostSession(
      transport: InMemoryTransport(network),
      newBots: (_) => InlineBotRunner(budget: budget, random: Random(1)),
      timing: SessionTiming.instant,
      newDeals: (random) =>
          PresetHandDealSource({0: CardSet.parse('D7')}, random),
    );
    await host.create(const HostConfig(
        gameName: 'g', nickname: 'Ana', trickHold: Duration.zero));
    final client = newClient(network);
    await client.join(await findGame(network));
    await pumpEventQueue();
    host.act(const ChooseTrump(0, TrumpMode.hearts));
    expect(host.table!.meldChoiceFor, [0, 2]);
    host.meldsChosen();
    host.act(PlayCard(0, Card.parse('D7')));
    await pumpEventQueue(times: 50);
    expect(host.table!.seatToAct, 1);
    expect(host.table!.meldChoiceFor, [2]);

    client.meldsChosen();
    await host.tables.firstWhere((t) => t.seatToAct == 2);
    expect(host.table!.meldChoiceFor, isEmpty);
    await host.close();
  });

  test('a bot thinks while the humans are busy, and only once', () async {
    final network = InMemoryNetwork();
    final bots = RecordingBotRunner();
    final host = HostSession(
      transport: InMemoryTransport(network),
      newBots: (_) => bots,
      timing: SessionTiming.instant,
      newDeals: (random) =>
          PresetHandDealSource({0: CardSet.parse('D7')}, random),
    );
    await host.create(const HostConfig(
        gameName: 'g', nickname: 'Ana', trickHold: Duration.zero));
    final client = newClient(network);
    await client.join(await findGame(network));
    await pumpEventQueue();
    host.act(const ChooseTrump(0, TrumpMode.hearts));
    host.meldsChosen();
    host.act(PlayCard(0, Card.parse('D7')));
    await pumpEventQueue(times: 50);
    expect(host.table!.meldChoiceFor, [2]); // The joiner is still choosing.
    expect(bots.decidedFor, [1]);

    client.meldsChosen();
    await host.tables.firstWhere((t) => t.seatToAct == 2);
    expect(bots.decidedFor, [1]);
    await host.close();
  });

  test('the bot choosing trump next thinks during the round summary', () async {
    final network = InMemoryNetwork();
    final bots = RecordingBotRunner();
    final host = HostSession(
      transport: InMemoryTransport(network),
      newBots: (_) => bots,
      timing: const SessionTiming(
          botDelay: Duration.zero,
          trickSlide: Duration.zero,
          popup: Duration(milliseconds: 100)),
      // The host chooses trump first, so Ordi 1 chooses it next.
      newDeals: (random) =>
          PresetHandDealSource({0: CardSet.parse('D7')}, random),
    );
    await host.create(const HostConfig(
        gameName: 'g',
        nickname: 'Ana',
        options: options,
        trickHold: Duration.zero));
    final client = newClient(network);
    await client.join(await findGame(network));
    autoplay(host.tables, host.act, host.meldsChosen);
    autoplay(client.tables, client.act, client.meldsChosen);
    await pumpEventQueue();
    host.act(HeuristicPlayer().decide(host.table!.player!));

    await host.tables.firstWhere((t) => t.phase == TablePhase.roundOver);
    expect(bots.decidedFor.last, 1);
    final decisions = bots.decidedFor.length;
    await host.tables.firstWhere((t) => t.roundIndex == 1);
    expect(bots.decidedFor.length, decisions);
    await host.close();
  });

  group('the meld recap after the first trick', () {
    /// The host announces a sequence in the first trick; resolves once the
    /// recap is shown.
    Future<(HostSession, ClientSession, StreamSubscription<TableView>)>
        playFirstTrick(Duration recap) async {
      final network = InMemoryNetwork();
      final host = HostSession(
        transport: InMemoryTransport(network),
        newBots: (_) => InlineBotRunner(budget: budget, random: Random(1)),
        timing: SessionTiming(
            botDelay: Duration.zero, trickSlide: Duration.zero, popup: recap),
        newDeals: (random) =>
            PresetHandDealSource({0: CardSet.parse('D7 H7 H8 H9 H10')}, random),
      );
      await host.create(const HostConfig(
          gameName: 'g', nickname: 'Ana', trickHold: Duration.zero));
      final client = newClient(network);
      await client.join(await findGame(network));
      final clientPlay =
          autoplay(client.tables, client.act, client.meldsChosen);
      final shown = host.tables.firstWhere((t) => t.recapFor.isNotEmpty);
      await pumpEventQueue();
      host.act(const ChooseTrump(0, TrumpMode.hearts));
      final sequence = Meld.fromCards(CardSet.parse('H7 H8 H9 H10'))!;
      host.act(PlayCard(0, Card.parse('D7'), melds: [sequence]));
      final table = await shown;
      expect(table.recapFor, [0, 2]);
      expect(table.showsRecap, isTrue);
      expect(table.isMyTurn, isFalse);
      return (host, client, clientPlay);
    }

    test('ends once both humans closed it', () async {
      final (host, client, clientPlay) =
          await playFirstTrick(const Duration(minutes: 1));
      client.dismissRecap();
      await host.tables.firstWhere((t) => t.recapFor.length == 1);
      expect(host.table!.showsRecap, isTrue);
      expect(() => host.act(PlayCard(0, host.table!.player!.hand.cards.first)),
          throwsA(isA<IllegalActionException>()));
      host.dismissRecap();
      expect(host.table!.recapFor, isEmpty);
      await clientPlay.cancel();
      await host.close();
    });

    test('ends by itself after its duration', () async {
      final (host, _, clientPlay) =
          await playFirstTrick(const Duration(milliseconds: 50));
      await host.tables.firstWhere((t) => t.recapFor.isEmpty);
      await clientPlay.cancel();
      await host.close();
    });
  });

  group('the round summary', () {
    /// Plays the first round; resolves once its summary is shown.
    Future<(HostSession, ClientSession, List<TableView>)> playRound(
        Duration summary) async {
      final network = InMemoryNetwork();
      final host = HostSession(
        transport: InMemoryTransport(network),
        newBots: (_) => InlineBotRunner(budget: budget, random: Random(1)),
        timing: SessionTiming(
            botDelay: Duration.zero,
            trickSlide: const Duration(milliseconds: 20),
            popup: summary),
        random: Random(2),
      );
      await host.create(const HostConfig(
          gameName: 'g',
          nickname: 'Ana',
          options: options,
          trickHold: Duration.zero));
      final client = newClient(network);
      await client.join(await findGame(network));
      final tables = <TableView>[];
      host.tables.listen(tables.add);
      autoplay(host.tables, host.act, host.meldsChosen);
      autoplay(client.tables, client.act, client.meldsChosen);
      // The recap of the announcements shares the summary's long timeout.
      host.tables.listen((t) {
        if (t.showsRecap) host.dismissRecap();
      });
      client.tables.listen((t) {
        if (t.showsRecap) client.dismissRecap();
      });
      await pumpEventQueue();
      if (host.table!.isMyTurn) {
        host.act(HeuristicPlayer().decide(host.table!.player!));
      }
      final table =
          await host.tables.firstWhere((t) => t.roundSummaryFor.isNotEmpty);
      expect(table.roundSummaryFor, [0, 2]);
      expect(table.showsRoundSummary, isTrue);
      expect(table.phase, TablePhase.roundOver);
      // Not shown while the last trick slides to its winner.
      final roundOver =
          tables.firstWhere((t) => t.phase == TablePhase.roundOver);
      expect(roundOver.roundSummaryFor, isEmpty);
      return (host, client, tables);
    }

    test('the next round starts once both humans closed it', () async {
      final (host, client, _) = await playRound(const Duration(minutes: 1));
      client.dismissRoundSummary();
      await host.tables.firstWhere((t) => t.roundSummaryFor.length == 1);
      expect(host.table!.phase, TablePhase.roundOver);
      expect(host.table!.showsRoundSummary, isTrue);
      final next = host.tables.firstWhere((t) => t.roundIndex == 1);
      host.dismissRoundSummary();
      expect((await next).roundSummaryFor, isEmpty);
      await host.close();
    });

    test('ends by itself after its duration', () async {
      final (host, _, _) = await playRound(const Duration(milliseconds: 50));
      await host.tables.firstWhere((t) => t.roundIndex == 1);
      await host.close();
    });
  });

  test('Stöck is recapped after the trick in which it was announced', () async {
    final network = InMemoryNetwork();
    final host = HostSession(
      transport: InMemoryTransport(network),
      newBots: (_) => InlineBotRunner(budget: budget, random: Random(1)),
      timing: const SessionTiming(
          botDelay: Duration.zero,
          trickSlide: Duration.zero,
          popup: Duration(minutes: 1)),
      newDeals: (random) => PresetHandDealSource(
          {0: CardSet.parse('D7 S6 S7 S8 S9 S10 SJ SQ SK')}, random),
    );
    await host.create(const HostConfig(
        gameName: 'g', nickname: 'Ana', trickHold: Duration.zero));
    final client = newClient(network);
    await client.join(await findGame(network));
    final clientPlay = autoplay(client.tables, client.act, client.meldsChosen);
    final king = Card.parse('SK'), queen = Card.parse('SQ');
    // The host plays the king first, then the queen with Stöck.
    final hostPlay = host.tables.listen((_) {
      final table = host.table!; // Events may be stale.
      if (table.showsRecap && table.player!.stoeckSeat == null) {
        // The bots' melds after the first trick.
        host.dismissRecap();
        client.dismissRecap();
      }
      if (!table.isMyTurn || table.phase != TablePhase.playing) return;
      final player = table.player!;
      final legal = player.legalCards;
      if (legal.contains(king)) {
        host.act(PlayCard(0, king));
      } else if (legal.contains(queen)) {
        host.act(PlayCard(0, queen, stoeck: true));
      } else {
        host.act(PlayCard(0, legal.cards.first));
      }
    });
    final recap = host.tables
        .firstWhere((t) => t.recapFor.isNotEmpty && t.player!.stoeckSeat == 0);
    await pumpEventQueue();
    host.act(const ChooseTrump(0, TrumpMode.spades));
    host.meldsChosen();
    final table = await recap;
    final tricks = table.player!.completedTricks;
    expect(stoeckTrickIndex(tricks, 0, TrumpMode.spades), tricks.length - 1);
    expect(table.recapFor, [0, 2]);
    client.dismissRecap();
    host.dismissRecap();
    await host.tables.firstWhere((t) => t.recapFor.isEmpty);
    await hostPlay.cancel();
    await clientPlay.cancel();
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
    autoplay(host.tables, host.act, host.meldsChosen);
    final clientPlay = autoplay(client.tables, client.act, client.meldsChosen);
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
    final hostPlay = autoplay(host.tables, host.act, host.meldsChosen);
    final clientPlay = autoplay(client.tables, client.act, client.meldsChosen);
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

  group('a single player game', () {
    const soloConfig = HostConfig(
        gameName: 'Partie solo',
        nickname: 'Ana',
        options: options,
        trickHold: Duration.zero,
        solo: true);

    test('starts at once, with a computer partner, without the network',
        () async {
      final network = InMemoryNetwork();
      final bots = RecordingBotRunner();
      final host = newHost(network, bots: bots);
      await host.create(soloConfig);
      expect(host.table!.phase, isNot(TablePhase.waitingForPlayer));
      expect(host.table!.isPaused, isFalse);
      expect(host.table!.solo, isTrue);
      expect(host.table!.nicknames, ['Ana', 'Ordi 1', 'Partenaire', 'Ordi 2']);
      expect(host.address, isNull);
      expect(await InMemoryTransport(network).discover().first, isEmpty);

      autoplay(host.tables, host.act, host.meldsChosen);
      if (host.table!.isMyTurn) {
        host.act(HeuristicPlayer().decide(host.table!.player!));
      }
      final end = await host.tables.firstWhere(
          (t) => t.phase == TablePhase.gameOver && t.insights != null);
      expect(end.scores.reduce(max), greaterThanOrEqualTo(300));
      expect(bots.decidedFor, containsAll([1, 2, 3]));
      expect(bots.decidedFor, isNot(contains(0)));
      expect(end.insights!.map((b) => b.seat).toSet(), isNot(contains(2)));

      host.proposeRematch(sameCards: false);
      expect(host.table!.phase, isNot(TablePhase.gameOver));
      expect(host.table!.scores, [0, 0]);
      await host.close();
    });

    test('resumes without waiting for anyone', () async {
      final network = InMemoryNetwork();
      final store = MemoryStore();
      final host = newHost(network, store: store);
      await host.create(soloConfig);
      expect(await HostSession.savedGameName(store), 'Partie solo');

      final restarted = newHost(network, store: store);
      await restarted.resume();
      expect(restarted.table!.isPaused, isFalse);
      expect(restarted.table!.solo, isTrue);
      expect(restarted.table!.nicknames[2], 'Partenaire');
      await restarted.close();
      await host.close();
    });
  });
}
