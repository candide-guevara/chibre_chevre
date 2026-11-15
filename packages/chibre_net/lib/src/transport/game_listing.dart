import '../proto/chibre.pb.dart' as pb;

/// The wire protocol version of this build; phones with different versions
/// cannot play together.
final int currentProtocolVersion =
    pb.ProtocolVersion.PROTOCOL_VERSION_CURRENT.value;

/// What a host publishes about its game so other phones can list it.
class GameListing {
  const GameListing({
    required this.gameId,
    required this.name,
    required this.hostNickname,
    this.reservedFor,
    this.scores = const [0, 0],
    this.protocolVersion,
  });

  final String gameId;
  final String name;
  final String hostNickname;

  /// Installation id of the only player who may (re)join a paused game; null
  /// for a new game anybody can join.
  final String? reservedFor;
  final List<int> scores;

  /// The host's protocol version, as heard from its advert; null when it is
  /// this build's.
  final int? protocolVersion;

  bool get isPaused => reservedFor != null;

  bool get isCompatible =>
      protocolVersion == null || protocolVersion == currentProtocolVersion;

  bool joinableBy(String installationId) =>
      isCompatible && (reservedFor == null || reservedFor == installationId);
}
