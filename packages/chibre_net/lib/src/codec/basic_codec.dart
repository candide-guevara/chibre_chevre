import 'package:chibre_core/chibre_core.dart';
import 'package:fixnum/fixnum.dart';

import '../proto/chibre.pb.dart' as pb;

Int64 encodeCards(CardSet cards) => Int64(cards.bits);

CardSet decodeCards(Int64 bits) => CardSet(bits.toInt());

/// Encodes a trump mode; null (no trump yet, or chibrer) is NONE.
pb.TrumpMode encodeMode(TrumpMode? mode) =>
    pb.TrumpMode.valueOf(mode == null ? 0 : mode.index + 1)!;

TrumpMode? decodeMode(pb.TrumpMode mode) =>
    mode.value == 0 ? null : TrumpMode.values[mode.value - 1];

pb.GameOptions encodeOptions(GameOptions options) => pb.GameOptions(
      targetScore: options.targetScore,
      obenUndeAllowed: options.obenUndeAllowed,
      multipliersEnabled: options.multipliersEnabled,
    );

GameOptions decodeOptions(pb.GameOptions options) => GameOptions(
      targetScore: options.targetScore,
      obenUndeAllowed: options.obenUndeAllowed,
      multipliersEnabled: options.multipliersEnabled,
    );

Meld decodeMeld(Int64 bits) {
  final meld = Meld.fromCards(decodeCards(bits));
  if (meld == null) throw FormatException('Not a meld: $bits');
  return meld;
}

/// -1 stands for "none" in optional seat, team and card fields.
int encodeOptional(int? value) => value ?? -1;

int? decodeOptional(int value) => value < 0 ? null : value;
