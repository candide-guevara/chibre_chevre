import 'package:chibre_core/chibre_core.dart';

import '../proto/chibre.pb.dart' as pb;
import 'action_codec.dart';
import 'basic_codec.dart';

pb.GameRecord encodeRecord(GameRecord record) => pb.GameRecord(
      options: encodeOptions(record.options),
      rounds: [
        for (final round in record.rounds)
          pb.Round(
            deal: [for (final hand in round.deal) encodeCards(hand)],
            trumpChooser: round.trumpChooser,
            actions: [for (final action in round.actions) encodeAction(action)],
          ),
      ],
    );

GameRecord decodeRecord(pb.GameRecord record) {
  final result = GameRecord(decodeOptions(record.options));
  for (final round in record.rounds) {
    result.rounds.add(RoundRecord(
      deal: [for (final bits in round.deal) decodeCards(bits)],
      trumpChooser: round.trumpChooser,
    )..actions.addAll(round.actions.map(decodeAction)));
  }
  return result;
}

/// Rebuilds the game state at the end of [record] by replaying it.
GameState replayRecord(GameRecord record) {
  final game = GameState.replaying(record);
  for (final (index, round) in record.rounds.indexed) {
    if (index > 0) game.startNextRound();
    round.actions.forEach(game.apply);
  }
  return game;
}
