import 'dart:typed_data';

/// A two-way channel of binary messages between the host and a joiner.
abstract interface class Connection {
  /// Incoming messages, in order. Done when the connection is closed or lost.
  Stream<Uint8List> get messages;

  void send(Uint8List message);

  Future<void> close();
}
