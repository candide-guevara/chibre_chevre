import '../engine/game_action.dart';
import '../engine/trump_mode.dart';

/// One of the choices of a player who must pick trump.
final class TrumpOption {
  const TrumpOption.mode(TrumpMode this.mode);

  const TrumpOption.chibrer() : mode = null;

  /// The trump mode, null for chibrer.
  final TrumpMode? mode;

  bool get isChibrer => mode == null;

  GameAction toAction(int seat) =>
      isChibrer ? Chibrer(seat) : ChooseTrump(seat, mode!);

  static TrumpOption ofAction(GameAction action) => switch (action) {
        ChooseTrump(:final mode) => TrumpOption.mode(mode),
        Chibrer() => const TrumpOption.chibrer(),
        PlayCard() => throw ArgumentError('$action is not a trump choice'),
      };

  @override
  bool operator ==(Object other) => other is TrumpOption && other.mode == mode;

  @override
  int get hashCode => mode.hashCode;

  @override
  String toString() => isChibrer ? 'chibrer' : mode!.name;
}
