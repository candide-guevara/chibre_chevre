import 'dart:isolate';

import 'package:chibre_core/chibre_core.dart';

import 'profile_store.dart';

/// Keep in sync with `version` in pubspec.yaml: a new version re-runs the
/// benchmark, as the AI may have become faster or slower.
const appVersion = '0.1.0';

/// The computer players' budget for this phone, from a benchmark run once
/// per app version in a background isolate.
Future<ComputeBudget> loadComputeBudget(ProfileStore profile) async {
  var speed = profile.playoutsPerSecond(appVersion);
  if (speed == null) {
    final measured = await Isolate.run(() => measurePlayoutsPerSecond());
    await profile.setPlayoutsPerSecond(appVersion, measured);
    speed = measured;
  }
  return ComputeBudget.forSpeed(speed);
}
