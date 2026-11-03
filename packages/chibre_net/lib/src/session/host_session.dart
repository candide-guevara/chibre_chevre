import 'dart:async';
import 'dart:math';

import 'package:chibre_core/chibre_core.dart';

import '../codec/action_codec.dart';
import '../codec/record_codec.dart';
import '../codec/table_codec.dart';
import '../proto/chibre.pb.dart' as pb;
import '../transport/advertisement.dart';
import '../transport/connection.dart';
import '../transport/game_listing.dart';
import '../transport/game_server.dart';
import '../transport/transport.dart';
import 'bot_runner.dart';
import 'card_style.dart';
import 'host_config.dart';
import 'saved_game_store.dart';
import 'session_timing.dart';
import 'table_view.dart';

/// Runs a game on the host phone. The host is authoritative: it holds the
/// game state, runs the computer players, checks the joiner's actions and
/// sends each human only what their seat may see.
class HostSession {
  HostSession({
    required this.transport,
    required this.bots,
    this.store,
    this.timing = const SessionTiming(),
    Random? random,
  }) : _random = random ?? Random();

  static const hostSeat = 0;
  static const joinerSeat = 2;

  final Transport transport;
  final BotRunner bots;
  final SavedGameStore? store;
  final SessionTiming timing;
  final Random _random;

  final _tables = StreamController<TableView>.broadcast();
  TableView? _table;

  late String _gameId;
  late String _gameName;
  late GameOptions _options;
  late List<String> _nicknames;
  late CardStyle _cardStyle;
  String? _joinerId;
  GameState? _game;
  GameServer? _server;
  Advertisement? _advertisement;
  Future<void> _advertising = Future.value();
  Connection? _joiner;
  var _hostAway = false;
  var _joinerAway = false;
  String? _leftBy;
  RematchOffer? _rematch;
  List<Blunder>? _insights;
  var _analysing = false;
  var _version = 0;
  Timer? _timer;
  var _closed = false;

  /// The host's table, after every change.
  Stream<TableView> get tables => _tables.stream;

  TableView? get table => _table;

  /// Where joiners connect, e.g. to type it in by hand in debug builds.
  String? get address => _server?.address;

  /// The name of the game saved in [store], if there is one to resume.
  static Future<String?> savedGameName(SavedGameStore store) async {
    final bytes = await store.load();
    return bytes == null ? null : pb.SavedGame.fromBuffer(bytes).gameName;
  }

  /// Starts a new game and waits for a player to join.
  Future<void> create(HostConfig config) async {
    _gameId = List.generate(4, (_) => _random.nextInt(1 << 32))
        .map((n) => n.toRadixString(16))
        .join();
    _gameName = config.gameName;
    _options = config.options;
    _nicknames = [config.nickname, 'Ordi 1', '', 'Ordi 2'];
    _cardStyle = _randomStyle();
    await _open();
  }

  /// Resumes the game saved in [store], waiting for the joiner to reconnect.
  Future<void> resume() async {
    final saved = pb.SavedGame.fromBuffer((await store!.load())!);
    final record = decodeRecord(saved.record);
    _gameId = saved.gameId;
    _gameName = saved.gameName;
    _options = record.options;
    _nicknames = List.of(saved.nicknames);
    _joinerId = saved.joinerInstallationId;
    _cardStyle = CardStyle.values[saved.cardStyle.value];
    _game = replayRecord(record);
    await _open();
  }

  /// Plays an action of the host's seat.
  void act(GameAction action) {
    if (action.seat != hostSeat) throw ArgumentError('Not the host seat');
    _applyHuman(action);
  }

  void proposeRematch({required bool sameCards}) =>
      _proposeRematch(hostSeat, sameCards);

  void answerRematch({required bool accept}) =>
      _answerRematch(hostSeat, accept);

  /// The host app went to the background (or came back): pause the game.
  void setAway(bool away) {
    _hostAway = away;
    _changed();
  }

  /// Ends the game for both players.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _timer?.cancel();
    _send(pb.HostMessage(closed: pb.Closed()));
    await _joiner?.close();
    await _stopAdvertising();
    await _server?.close();
    await store?.clear();
    await _tables.close();
  }

  Future<void> _open() async {
    _server = await transport.listen();
    _server!.connections.listen(_accept);
    _changed();
  }

  CardStyle _randomStyle() =>
      CardStyle.values[_random.nextInt(CardStyle.values.length)];

  void _startGame({DealSource? deals}) {
    _game =
        GameState(options: _options, deals: deals ?? RandomDealSource(_random));
    _cardStyle = _randomStyle();
    _insights = null;
    _analysing = false;
  }

  String? get _pausedFor {
    if (_game == null) return null;
    if (_joiner == null || _joinerAway) return _nicknames[joinerSeat];
    if (_hostAway) return _nicknames[hostSeat];
    return null;
  }

  bool get _isOver => _closed || _leftBy != null;

  // ------------------------------------------------------------- Updates

  void _changed() {
    if (_closed) return;
    _version++;
    _table = _tableFor(hostSeat);
    _tables.add(_table!);
    if (_game != null) {
      _send(pb.HostMessage(table: encodeTable(_tableFor(joinerSeat))));
    }
    _updateAdvertisement();
    _save();
    _schedule();
  }

  TableView _tableFor(int seat) {
    final game = _game;
    if (game == null) {
      return TableView(
        seat: seat,
        nicknames: List.unmodifiable(_nicknames),
        options: _options,
        cardStyle: _cardStyle,
        phase: TablePhase.waitingForPlayer,
        roundIndex: 0,
        scores: const [0, 0],
      );
    }
    final phase = switch (game.phase) {
      GamePhase.choosingTrump => TablePhase.choosingTrump,
      GamePhase.playing => TablePhase.playing,
      GamePhase.roundOver => TablePhase.roundOver,
      GamePhase.gameOver => TablePhase.gameOver,
    };
    final acting =
        phase == TablePhase.choosingTrump || phase == TablePhase.playing;
    return TableView(
      seat: seat,
      nicknames: List.unmodifiable(_nicknames),
      options: _options,
      cardStyle: _cardStyle,
      phase: phase,
      roundIndex: game.roundIndex,
      scores: game.scores,
      player: game.viewFor(seat),
      seatToAct: acting ? game.seatToAct : null,
      roundPoints: game.round.points,
      winningTeam: game.winningTeam,
      pausedFor: _pausedFor,
      rematch: _rematch,
      insights: _insights,
      leftBy: _leftBy,
    );
  }

  void _send(pb.HostMessage message) => _joiner?.send(message.writeToBuffer());

  /// Lists the game while it waits for a player, or for the joiner to come
  /// back; a full game is not listed.
  void _updateAdvertisement() {
    final listed = !_isOver && (_game == null || _joiner == null);
    if (!listed) {
      _stopAdvertising();
      return;
    }
    final listing = GameListing(
      gameId: _gameId,
      name: _gameName,
      hostNickname: _nicknames[hostSeat],
      reservedFor: _game == null ? null : _joinerId,
      scores: _game?.scores ?? const [0, 0],
    );
    _advertising = _advertising.then((_) async {
      if (_advertisement == null) {
        _advertisement = await transport.advertise(_server!, listing);
      } else {
        _advertisement!.update(listing);
      }
    });
  }

  Future<void> _stopAdvertising() =>
      _advertising = _advertising.then((_) async {
        await _advertisement?.stop();
        _advertisement = null;
      });

  void _save() {
    final game = _game;
    final store = this.store;
    if (store == null || game == null) return;
    if (_isOver || game.phase == GamePhase.gameOver) {
      store.clear();
      return;
    }
    store.save(pb.SavedGame(
      gameId: _gameId,
      gameName: _gameName,
      nicknames: _nicknames,
      joinerInstallationId: _joinerId,
      cardStyle: pb.CardStyle.valueOf(_cardStyle.index),
      record: encodeRecord(game.record),
    ).writeToBuffer());
  }

  // ------------------------------------------------------------- Game flow

  /// Plans what happens next when no human has to act: a computer player's
  /// move, the next deal, or the analysis of a finished game.
  void _schedule() {
    _timer?.cancel();
    _timer = null;
    final game = _game;
    if (game == null || _isOver || _pausedFor != null) return;
    final version = _version;
    switch (game.phase) {
      case GamePhase.gameOver:
        if (_insights == null && !_analysing) _analyse(game);
      case GamePhase.roundOver:
        _timer = Timer(timing.roundSummary, () {
          if (version != _version) return;
          game.startNextRound();
          _changed();
        });
      case GamePhase.choosingTrump || GamePhase.playing:
        final seat = game.seatToAct;
        if (seat == hostSeat || seat == joinerSeat) return;
        final round = game.round;
        final trickJustEnded = round.currentTrick?.isEmpty == true &&
            round.completedTricks.isNotEmpty;
        _timer = Timer(trickJustEnded ? timing.trickPause : Duration.zero,
            () => _playBot(game, seat, version));
    }
  }

  Future<void> _playBot(GameState game, int seat, int version) async {
    final results = await Future.wait([
      bots.decide(game.viewFor(seat)),
      Future<void>.delayed(timing.botDelay),
    ]);
    if (version != _version || _pausedFor != null || _isOver) return;
    game.apply(results.first as GameAction);
    _changed();
  }

  Future<void> _analyse(GameState game) async {
    _analysing = true;
    final blunders = await bots.analyse(game.record);
    if (_game != game || _closed) return;
    _insights = [...?blunders[hostSeat], ...?blunders[joinerSeat]];
    _analysing = false;
    _changed();
  }

  void _applyHuman(GameAction action) {
    final game = _game;
    if (game == null || _isOver) {
      throw const IllegalActionException('No game in progress');
    }
    if (_pausedFor != null) {
      throw const IllegalActionException('The game is paused');
    }
    game.apply(action);
    _changed();
  }

  void _proposeRematch(int seat, bool sameCards) {
    if (_game?.phase != GamePhase.gameOver || _isOver) return;
    _rematch = RematchOffer(proposedBy: seat, sameCards: sameCards);
    _changed();
  }

  void _answerRematch(int seat, bool accept) {
    final offer = _rematch;
    if (offer == null || offer.proposedBy == seat) return;
    _rematch = null;
    if (accept) {
      _startGame(
          deals: offer.sameCards
              ? ReplayDealSource(_game!.record.deals,
                  fallback: RandomDealSource(_random))
              : null);
    }
    _changed();
  }

  // ------------------------------------------------------------- Joiner

  void _accept(Connection connection) {
    var welcomed = false;
    connection.messages.listen(
      (bytes) {
        final pb.ClientMessage message;
        try {
          message = pb.ClientMessage.fromBuffer(bytes);
        } on Exception {
          connection.close();
          return;
        }
        if (welcomed) {
          if (connection == _joiner) _onJoinerMessage(message);
        } else if (message.hasHello()) {
          welcomed = _welcome(connection, message.hello);
        }
      },
      onDone: () {
        if (connection != _joiner) return;
        _joiner = null;
        _changed();
      },
    );
  }

  bool _welcome(Connection connection, pb.Hello hello) {
    void reject(pb.Rejected_Reason reason) {
      connection.send(pb.HostMessage(rejected: pb.Rejected(reason: reason))
          .writeToBuffer());
      connection.close();
    }

    if (hello.protocolVersion !=
        pb.ProtocolVersion.PROTOCOL_VERSION_CURRENT.value) {
      reject(pb.Rejected_Reason.REASON_VERSION_MISMATCH);
      return false;
    }
    final isNewPlayer = _game == null;
    if (_isOver || (!isNewPlayer && hello.installationId != _joinerId)) {
      reject(pb.Rejected_Reason.REASON_GAME_FULL);
      return false;
    }
    final previous = _joiner;
    _joiner = connection;
    previous?.close();
    _joinerId = hello.installationId;
    _joinerAway = false;
    _nicknames[joinerSeat] = hello.nickname;
    if (isNewPlayer) _startGame();
    connection.send(
        pb.HostMessage(welcome: pb.Welcome(seat: joinerSeat, gameId: _gameId))
            .writeToBuffer());
    _changed();
    return true;
  }

  void _onJoinerMessage(pb.ClientMessage message) {
    switch (message.whichBody()) {
      case pb.ClientMessage_Body.action:
        _onJoinerAction(message.action);
      case pb.ClientMessage_Body.proposeRematch:
        _proposeRematch(joinerSeat, message.proposeRematch.sameCards);
      case pb.ClientMessage_Body.answerRematch:
        _answerRematch(joinerSeat, message.answerRematch.accept);
      case pb.ClientMessage_Body.presence:
        _joinerAway = message.presence.away;
        _changed();
      case pb.ClientMessage_Body.leave:
        _leftBy = _nicknames[joinerSeat];
        _timer?.cancel();
        _changed();
        _joiner?.close();
      case pb.ClientMessage_Body.hello || pb.ClientMessage_Body.notSet:
        break;
    }
  }

  void _onJoinerAction(pb.Action message) {
    try {
      final action = decodeAction(message);
      if (action.seat != joinerSeat) {
        throw const IllegalActionException('Not the joiner seat');
      }
      _applyHuman(action);
    } on IllegalActionException catch (error) {
      _send(pb.HostMessage(
          actionRejected: pb.ActionRejected(reason: error.message)));
    } on FormatException catch (error) {
      _send(pb.HostMessage(
          actionRejected: pb.ActionRejected(reason: error.message)));
    }
  }
}
