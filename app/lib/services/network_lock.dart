import 'dart:io';

import 'package:flutter/services.dart';

const _channel = MethodChannel('chibre/network');

/// Asks Android to deliver the broadcast packets used to find games (some
/// phones drop them to save battery). Does nothing on other platforms.
Future<void> acquireMulticastLock() async {
  if (!Platform.isAndroid) return;
  await _channel.invokeMethod<void>('acquireMulticastLock');
}
