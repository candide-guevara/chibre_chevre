/// How much computation the AI may spend, derived from the phone's speed so
/// the strongest play is reached while keeping the game snappy.
class ComputeBudget {
  const ComputeBudget({
    required this.searchIterations,
    required this.trumpSamples,
    required this.analysisSamples,
    this.timeLimit,
  });

  /// [playoutsPerSecond] is measured by `measurePlayoutsPerSecond`.
  factory ComputeBudget.forSpeed(
    double playoutsPerSecond, {
    Duration target = const Duration(milliseconds: 1000),
  }) {
    final playouts = playoutsPerSecond * target.inMicroseconds / 1e6;
    return ComputeBudget(
      searchIterations: playouts.round().clamp(200, 50000),
      // Each trump sample plays one round per option (up to 7).
      trumpSamples: (playouts / 7).round().clamp(30, 5000),
      // A fifth of the target per analysed decision, ~4 legal cards each.
      analysisSamples: (playouts / 20).round().clamp(20, 500),
      timeLimit: target * 1.5,
    );
  }

  /// Used before the phone's speed is known.
  static const standard = ComputeBudget(
    searchIterations: 2000,
    trumpSamples: 300,
    analysisSamples: 100,
  );

  /// Search iterations per card played.
  final int searchIterations;

  /// Sampled deals per trump decision.
  final int trumpSamples;

  /// Sampled deals per decision analysed by the insights.
  final int analysisSamples;

  /// Hard limit per decision, in case the phone is busier than measured.
  final Duration? timeLimit;
}
