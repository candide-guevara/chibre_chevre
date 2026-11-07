import 'package:chibre_core/chibre_core.dart';

import 'card_style.dart';
import 'host_config.dart';

enum TablePhase {
  waitingForPlayer,
  choosingTrump,
  playing,
  roundOver,
  gameOver
}

class RematchOffer {
  const RematchOffer({required this.proposedBy, required this.sameCards});

  final int proposedBy;

  /// Whether the rematch replays the same deals.
  final bool sameCards;
}

/// Everything a human player's screen shows. The host builds one per human
/// seat; the joiner receives its own over the network.
class TableView {
  const TableView({
    required this.seat,
    required this.nicknames,
    required this.options,
    required this.cardStyle,
    required this.phase,
    required this.roundIndex,
    required this.scores,
    this.player,
    this.seatToAct,
    this.roundPoints = const [0, 0],
    this.winningTeam,
    this.pausedFor,
    this.rematch,
    this.insights,
    this.leftBy,
    this.trickHold = HostConfig.defaultTrickHold,
    this.recapFor = const [],
    this.meldChoiceFor = const [],
    this.assistance = false,
    this.sortByTrump = false,
    this.autoAnnounce = false,
  });

  final int seat;

  /// By seat.
  final List<String> nicknames;
  final GameOptions options;
  final CardStyle cardStyle;
  final TablePhase phase;
  final int roundIndex;

  /// Game scores by team.
  final List<int> scores;

  /// What the player sees of the current round; null while waiting for the
  /// other player.
  final PlayerView? player;

  /// The seat expected to act, null when nobody must act.
  final int? seatToAct;

  /// Points of the current round by team.
  final List<int> roundPoints;
  final int? winningTeam;

  /// Nickname of the player the game waits for, null when not paused.
  final String? pausedFor;
  final RematchOffer? rematch;

  /// The biggest blunders of both humans, null until computed.
  final List<Blunder>? insights;

  /// Set when the other human left: the game is over for good.
  final String? leftBy;

  /// How long a complete trick stays before sliding to its winner.
  final Duration trickHold;

  /// The seats still reading the recap of the announcements (melds, Stöck);
  /// nobody plays until it is empty.
  final List<int> recapFor;

  /// The humans still choosing their melds; the computer players wait.
  final List<int> meldChoiceFor;

  /// Whether the play screen shows the "Jouer pour moi" and "Cartes jouées"
  /// buttons.
  final bool assistance;

  /// Whether hands are sorted by trump rather than in a fixed suit order.
  final bool sortByTrump;

  /// Whether Stöck is announced automatically and the melds are offered in
  /// a pop-up rather than selected card by card.
  final bool autoAnnounce;

  /// Whether this player should see the recap of the announcements.
  bool get showsRecap => recapFor.contains(seat);

  bool get isPaused => pausedFor != null;

  bool get isMyTurn =>
      !isPaused && leftBy == null && recapFor.isEmpty && seatToAct == seat;

  /// A copy with the given fields set (null keeps the current value).
  TableView copyWith({String? pausedFor, String? leftBy}) => TableView(
        seat: seat,
        nicknames: nicknames,
        options: options,
        cardStyle: cardStyle,
        phase: phase,
        roundIndex: roundIndex,
        scores: scores,
        player: player,
        seatToAct: seatToAct,
        roundPoints: roundPoints,
        winningTeam: winningTeam,
        pausedFor: pausedFor ?? this.pausedFor,
        rematch: rematch,
        insights: insights,
        leftBy: leftBy ?? this.leftBy,
        trickHold: trickHold,
        recapFor: recapFor,
        meldChoiceFor: meldChoiceFor,
        assistance: assistance,
        sortByTrump: sortByTrump,
        autoAnnounce: autoAnnounce,
      );
}
