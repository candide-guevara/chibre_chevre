import 'package:chibre_core/chibre_core.dart';

import '../proto/chibre.pb.dart' as pb;
import 'basic_codec.dart';

pb.Blunder encodeBlunder(Blunder blunder) => pb.Blunder(
      kind: pb.Blunder_Kind.valueOf(blunder.kind.index),
      seat: blunder.seat,
      roundIndex: blunder.roundIndex,
      trickIndex: encodeOptional(blunder.trickIndex),
      hand: encodeCards(blunder.hand),
      trick: [for (final card in blunder.trick) card.index],
      mode: encodeMode(blunder.mode),
      pointsLost: blunder.pointsLost,
      playedCard: encodeOptional(blunder.playedCard?.index),
      bestCard: encodeOptional(blunder.bestCard?.index),
      chosenTrump: encodeMode(blunder.chosenTrump?.mode),
      bestTrump: encodeMode(blunder.bestTrump?.mode),
      missedMelds: [
        for (final meld in blunder.missedMelds) encodeCards(meld.cards)
      ],
    );

Blunder decodeBlunder(pb.Blunder blunder) {
  final kind = BlunderKind.values[blunder.kind.value];
  final isTrumpChoice = kind == BlunderKind.trumpChoice;
  return Blunder(
    kind: kind,
    seat: blunder.seat,
    roundIndex: blunder.roundIndex,
    trickIndex: decodeOptional(blunder.trickIndex),
    hand: decodeCards(blunder.hand),
    trick: [for (final index in blunder.trick) Card.fromIndex(index)],
    mode: decodeMode(blunder.mode),
    pointsLost: blunder.pointsLost,
    playedCard: _decodeCard(blunder.playedCard),
    bestCard: _decodeCard(blunder.bestCard),
    chosenTrump: isTrumpChoice ? _decodeOption(blunder.chosenTrump) : null,
    bestTrump: isTrumpChoice ? _decodeOption(blunder.bestTrump) : null,
    missedMelds: [for (final bits in blunder.missedMelds) decodeMeld(bits)],
  );
}

Card? _decodeCard(int index) => index < 0 ? null : Card.fromIndex(index);

TrumpOption _decodeOption(pb.TrumpMode mode) {
  final decoded = decodeMode(mode);
  return decoded == null
      ? const TrumpOption.chibrer()
      : TrumpOption.mode(decoded);
}
