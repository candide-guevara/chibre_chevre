import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../transport/connection.dart';
import 'frame_decoder.dart';

/// A connection over a TCP socket, messages being length prefixed frames.
class LanConnection implements Connection {
  LanConnection(this._socket) {
    _socket.setOption(SocketOption.tcpNoDelay, true);
    final decoder = FrameDecoder();
    _socket.listen(
      (bytes) {
        try {
          decoder.add(bytes).forEach(_messages.add);
        } on FormatException {
          close();
        }
      },
      onError: (_) => close(),
      onDone: close,
      cancelOnError: true,
    );
  }

  final Socket _socket;
  final _messages = StreamController<Uint8List>();
  var _closed = false;

  @override
  Stream<Uint8List> get messages => _messages.stream;

  @override
  void send(Uint8List message) {
    if (!_closed) _socket.add(encodeFrame(message));
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    unawaited(_messages.close());
    _socket.destroy();
  }
}
