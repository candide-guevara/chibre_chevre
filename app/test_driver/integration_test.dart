import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

/// Saves what `integration_test/play_frames_test.dart` reports to
/// `build/frame_bench/<FRAME_BENCH_LABEL>.json`.
Future<void> main() => integrationDriver(
  responseDataCallback: (data) => writeResponseData(
    data,
    testOutputFilename:
        Platform.environment['FRAME_BENCH_LABEL'] ?? 'play_frames',
    destinationDirectory: 'build/frame_bench',
  ),
);
