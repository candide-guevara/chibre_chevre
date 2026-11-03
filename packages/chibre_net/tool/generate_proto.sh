#!/usr/bin/env bash
# Regenerates the Dart protobuf classes from proto/chibre.proto.
# Needs protoc and `dart pub global activate protoc_plugin`.
set -euo pipefail
cd "$(dirname "$0")/.."
# dart must be on the PATH for the plugin; FLUTTER_ROOT defaults to ~/develop/flutter.
PATH="$HOME/.pub-cache/bin:${FLUTTER_ROOT:-$HOME/develop/flutter}/bin:$PATH" protoc \
  --proto_path=../../proto \
  --dart_out=lib/src/proto \
  ../../proto/chibre.proto
