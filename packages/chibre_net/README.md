# chibre_net

Pure Dart wire protocol, transports and game sessions for the Chibre Chèvre app.
See `SPECIFICATION.md` at the repository root.

- `lib/src/proto/`: generated from `proto/chibre.proto` (do not edit).
- `lib/src/codec/`: conversions between `chibre_core` types and protobuf.
- `lib/src/transport/`: the `Transport` abstraction (discovery + connections).
- `lib/src/lan/`: LAN implementation (UDP broadcast discovery, TCP).
- `lib/src/memory/`: in-process implementation for tests.
- `lib/src/session/`: `HostSession` (authoritative, runs the bots) and
  `ClientSession` (the joiner, reconnects by itself).

## Commands

```bash
dart pub get
dart test
dart analyze

# After editing proto/chibre.proto (needs protoc and
# `dart pub global activate protoc_plugin`):
tool/generate_proto.sh
```
