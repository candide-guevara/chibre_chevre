import 'dart:typed_data';

import 'package:chibre_net/src/lan/frame_decoder.dart';
import 'package:test/test.dart';

void main() {
  final first = Uint8List.fromList([1, 2, 3]);
  final second = Uint8List.fromList([4]);
  final stream = [...encodeFrame(first), ...encodeFrame(second)];

  test('decodes several frames received at once', () {
    expect(FrameDecoder().add(stream), [first, second]);
  });

  test('decodes frames split across chunks', () {
    final decoder = FrameDecoder();
    final frames = <Uint8List>[];
    for (final byte in stream) {
      frames.addAll(decoder.add([byte]));
    }
    expect(frames, [first, second]);
  });

  test('decodes empty frames', () {
    expect(FrameDecoder().add(encodeFrame(Uint8List(0))), [Uint8List(0)]);
  });

  test('refuses huge frames', () {
    expect(() => FrameDecoder().add([0xFF, 0xFF, 0xFF, 0xFF]),
        throwsFormatException);
  });
}
