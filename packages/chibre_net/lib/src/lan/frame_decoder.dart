import 'dart:typed_data';

/// Frames larger than this are refused, protecting against garbage input.
const maxFrameLength = 1 << 20;

/// Prefixes [payload] with its length (4 bytes, big endian), so messages can
/// be told apart in a TCP byte stream.
Uint8List encodeFrame(Uint8List payload) {
  final frame = Uint8List(4 + payload.length);
  ByteData.sublistView(frame).setUint32(0, payload.length);
  frame.setRange(4, frame.length, payload);
  return frame;
}

/// Splits a TCP byte stream back into the frames made by [encodeFrame].
class FrameDecoder {
  final _buffer = BytesBuilder(copy: false);

  /// Adds received bytes and returns the frames they complete.
  List<Uint8List> add(List<int> bytes) {
    _buffer.add(bytes);
    var data = _buffer.takeBytes();
    final frames = <Uint8List>[];
    while (data.length >= 4) {
      final length = ByteData.sublistView(data).getUint32(0);
      if (length > maxFrameLength) {
        throw FormatException('Frame of $length bytes is too large');
      }
      if (data.length < 4 + length) break;
      frames.add(Uint8List.fromList(data.sublist(4, 4 + length)));
      data = Uint8List.sublistView(data, 4 + length);
    }
    if (data.isNotEmpty) _buffer.add(data);
    return frames;
  }
}
