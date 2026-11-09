import 'dart:isolate';

import 'package:chibre_core/chibre_core.dart';

import 'profile_store.dart';

/// Keep in sync with `version` in pubspec.yaml: a new version re-runs the
/// benchmark, as the AI may have become faster or slower.
const appVersion = '0.2.0';

/// How many search iterations per second this phone runs, from a benchmark
/// run once per app version in a background isolate. Each game's thinking
/// time is turned into a budget with it, see [ComputeBudget.forSpeed].
Future<double> loadPlayoutsPerSecond(ProfileStore profile) async {
  final saved = profile.playoutsPerSecond(appVersion);
  if (saved != null) return saved;
  final measured = await Isolate.run(() => measurePlayoutsPerSecond());
  await profile.setPlayoutsPerSecond(appVersion, measured);
  return measured;
}
