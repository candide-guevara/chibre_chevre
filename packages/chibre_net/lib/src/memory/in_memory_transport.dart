import 'dart:async';
import 'dart:typed_data';

import '../transport/advertisement.dart';
import '../transport/connection.dart';
import '../transport/game_listing.dart';
import '../transport/game_server.dart';
import '../transport/open_game.dart';
import '../transport/transport.dart';

/// A network inside one process: phones are [InMemoryTransport]s sharing it.
/// Used by tests, and handy to try the app without a second phone.
class InMemoryNetwork {
  final _servers = <String, _InMemoryServer>{};
  final _listings = <String, OpenGame>{};
  final _changes = StreamController<List<OpenGame>>.broadcast();
  final _connections = <_InMemoryConnection>[];
  var _nextAddress = 0;

  List<OpenGame> get _openGames => List.unmodifiable(_listings.values);

  /// Simulates every phone losing the network.
  void disconnectAll() {
    for (final connection in List.of(_connections)) {
      connection.close();
    }
  }

  void _publish(String address, GameListing? listing) {
    if (listing == null) {
      _listings.remove(address);
    } else {
      _listings[address] = OpenGame(listing: listing, address: address);
    }
    _changes.add(_openGames);
  }
}

class InMemoryTransport implements Transport {
  InMemoryTransport(this.network);

  final InMemoryNetwork network;

  @override
  Future<GameServer> listen() async {
    final server = _InMemoryServer(network, 'memory:${network._nextAddress++}');
    network._servers[server.address] = server;
    return server;
  }

  @override
  Future<Advertisement> advertise(
      GameServer server, GameListing listing) async {
    final advertisement = _InMemoryAdvertisement(network, server.address);
    advertisement.update(listing);
    return advertisement;
  }

  @override
  Stream<List<OpenGame>> discover() async* {
    yield network._openGames;
    yield* network._changes.stream;
  }

  @override
  Future<Connection> connect(OpenGame game) async {
    final server = network._servers[game.address];
    if (server == null) throw StateError('No game at ${game.address}');
    final hostSide = _InMemoryConnection(network);
    final joinerSide = _InMemoryConnection(network);
    hostSide._peer = joinerSide;
    joinerSide._peer = hostSide;
    server._connections.add(hostSide);
    return joinerSide;
  }
}

class _InMemoryServer implements GameServer {
  _InMemoryServer(this._network, this.address);

  final InMemoryNetwork _network;
  final _connections = StreamController<Connection>();

  @override
  final String address;

  @override
  Stream<Connection> get connections => _connections.stream;

  @override
  Future<void> close() async {
    _network._servers.remove(address);
    await _connections.close();
  }
}

class _InMemoryAdvertisement implements Advertisement {
  _InMemoryAdvertisement(this._network, this._address);

  final InMemoryNetwork _network;
  final String _address;

  @override
  void update(GameListing listing) => _network._publish(_address, listing);

  @override
  Future<void> stop() async => _network._publish(_address, null);
}

class _InMemoryConnection implements Connection {
  _InMemoryConnection(this._network) {
    _network._connections.add(this);
  }

  final InMemoryNetwork _network;
  final _incoming = StreamController<Uint8List>();
  late _InMemoryConnection _peer;
  var _closed = false;

  @override
  Stream<Uint8List> get messages => _incoming.stream;

  @override
  void send(Uint8List message) {
    if (!_closed) _peer._incoming.add(message);
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _network._connections.remove(this);
    unawaited(_incoming.close());
    await _peer.close();
  }
}
