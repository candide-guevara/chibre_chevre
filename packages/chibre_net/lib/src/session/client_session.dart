import 'dart:async';

import 'package:chibre_core/chibre_core.dart';

import '../codec/action_codec.dart';
import '../codec/table_codec.dart';
import '../proto/chibre.pb.dart' as pb;
import '../transport/connection.dart';
import '../transport/open_game.dart';
import '../transport/transport.dart';
import 'join_rejected_exception.dart';
import 'table_view.dart';

/// The joiner's side of a game: renders what the host sends and forwards the
/// player's actions. Reconnects by itself when the connection is lost.
class ClientSession {
  ClientSession({
    required this.transport,
    required this.installationId,
    required this.nickname,
    this.retryInterval = const Duration(seconds: 2),
  });

  final Transport transport;
  final String installationId;
  final String nickname;
  final Duration retryInterval;

  final _tables = StreamController<TableView>.broadcast();
  final _rejectedActions = StreamController<String>.broadcast();
  TableView? _table;
  late OpenGame _game;
  String? _gameId;
  Connection? _connection;
  StreamSubscription<List<OpenGame>>? _discovery;
  Timer? _retry;
  var _connecting = false;
  var _ended = false;

  /// The joiner's table, after every change.
  Stream<TableView> get tables => _tables.stream;

  TableView? get table => _table;

  /// Why the host refused an action; shouldn't happen with a correct UI.
  Stream<String> get rejectedActions => _rejectedActions.stream;

  /// Joins [game]. Throws [JoinRejectedException] if the host refuses.
  Future<void> join(OpenGame game) {
    _game = game;
    return _connect(game);
  }

  void act(GameAction action) =>
      _send(pb.ClientMessage(action: encodeAction(action)));

  void proposeRematch({required bool sameCards}) => _send(pb.ClientMessage(
      proposeRematch: pb.ProposeRematch(sameCards: sameCards)));

  void answerRematch({required bool accept}) =>
      _send(pb.ClientMessage(answerRematch: pb.AnswerRematch(accept: accept)));

  /// The app went to the background (or came back): pauses the game.
  void setAway(bool away) =>
      _send(pb.ClientMessage(presence: pb.Presence(away: away)));

  /// The player chose their melds, or not to announce any.
  void meldsChosen() => _send(pb.ClientMessage(meldsChosen: pb.MeldsChosen()));

  /// The player closed the meld recap.
  void dismissMelds() =>
      _send(pb.ClientMessage(dismissMelds: pb.DismissMelds()));

  /// Leaves the game for good.
  Future<void> leave() async {
    _send(pb.ClientMessage(leave: pb.Leave()));
    await _end();
  }

  void _send(pb.ClientMessage message) =>
      _connection?.send(message.writeToBuffer());

  Future<void> _connect(OpenGame game) async {
    final connection = await transport.connect(game);
    final welcomed = Completer<void>();
    connection.messages.listen(
      (bytes) =>
          _onMessage(connection, pb.HostMessage.fromBuffer(bytes), welcomed),
      onDone: () {
        if (!welcomed.isCompleted) {
          welcomed.completeError(
              const JoinRejectedException(JoinRejection.unknown));
        }
        if (connection == _connection) _lost();
      },
    );
    connection.send(pb.ClientMessage(
      hello: pb.Hello(
        protocolVersion: pb.ProtocolVersion.PROTOCOL_VERSION_CURRENT.value,
        installationId: installationId,
        nickname: nickname,
      ),
    ).writeToBuffer());
    try {
      await welcomed.future.timeout(const Duration(seconds: 5));
    } catch (_) {
      await connection.close();
      rethrow;
    }
  }

  void _onMessage(
      Connection connection, pb.HostMessage message, Completer<void> welcomed) {
    switch (message.whichBody()) {
      case pb.HostMessage_Body.welcome:
        _gameId = message.welcome.gameId;
        _connection = connection;
        _stopReconnecting();
        welcomed.complete();
      case pb.HostMessage_Body.rejected:
        welcomed.completeError(
            JoinRejectedException(switch (message.rejected.reason) {
          pb.Rejected_Reason.REASON_VERSION_MISMATCH =>
            JoinRejection.versionMismatch,
          pb.Rejected_Reason.REASON_GAME_FULL => JoinRejection.gameFull,
          _ => JoinRejection.unknown,
        }));
      case pb.HostMessage_Body.table:
        _emit(decodeTable(message.table));
      case pb.HostMessage_Body.actionRejected:
        _rejectedActions.add(message.actionRejected.reason);
      case pb.HostMessage_Body.closed:
        final table = _table;
        if (table != null) {
          _emit(table.copyWith(leftBy: table.nicknames[partnerOf(table.seat)]));
        }
        _end();
      case pb.HostMessage_Body.notSet:
        break;
    }
  }

  void _emit(TableView table) {
    if (_ended) return;
    _table = table;
    _tables.add(table);
  }

  /// The host vanished: show the game as paused and try to get it back,
  /// following the host to its new address if it restarted.
  void _lost() {
    _connection = null;
    if (_ended) return;
    final table = _table;
    if (table != null) {
      _emit(table.copyWith(pausedFor: table.nicknames[partnerOf(table.seat)]));
    }
    _discovery ??= transport.discover().listen((games) {
      for (final game in games) {
        if (game.listing.gameId == _gameId &&
            game.listing.joinableBy(installationId)) {
          _game = game;
        }
      }
    });
    _retry ??= Timer.periodic(retryInterval, (_) => _tryReconnect());
  }

  Future<void> _tryReconnect() async {
    if (_connecting || _connection != null || _ended) return;
    _connecting = true;
    try {
      await _connect(_game);
    } catch (_) {
      // Not back yet; the next tick tries again.
    } finally {
      _connecting = false;
    }
  }

  void _stopReconnecting() {
    _retry?.cancel();
    _retry = null;
    _discovery?.cancel();
    _discovery = null;
  }

  Future<void> _end() async {
    if (_ended) return;
    _ended = true;
    _stopReconnecting();
    final connection = _connection;
    _connection = null;
    await connection?.close();
    await _tables.close();
    await _rejectedActions.close();
  }
}
