/// What a host publishes about its game so other phones can list it.
class GameListing {
  const GameListing({
    required this.gameId,
    required this.name,
    required this.hostNickname,
    this.reservedFor,
    this.scores = const [0, 0],
  });

  final String gameId;
  final String name;
  final String hostNickname;

  /// Installation id of the only player who may (re)join a paused game; null
  /// for a new game anybody can join.
  final String? reservedFor;
  final List<int> scores;

  bool get isPaused => reservedFor != null;

  bool joinableBy(String installationId) =>
      reservedFor == null || reservedFor == installationId;
}
