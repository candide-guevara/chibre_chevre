enum ScoreReason { stoeck, melds, trick }

/// Points scored by a team, multiplier included.
class ScoreEntry {
  const ScoreEntry(this.team, this.points, this.reason);

  final int team;
  final int points;
  final ScoreReason reason;

  @override
  String toString() => 'ScoreEntry(team $team, $points, ${reason.name})';
}
