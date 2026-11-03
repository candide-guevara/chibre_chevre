enum JoinRejection { versionMismatch, gameFull, unknown }

/// The host refused to let this phone join.
class JoinRejectedException implements Exception {
  const JoinRejectedException(this.reason);

  final JoinRejection reason;

  @override
  String toString() => 'JoinRejectedException(${reason.name})';
}
