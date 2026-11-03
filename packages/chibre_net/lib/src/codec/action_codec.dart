import 'package:chibre_core/chibre_core.dart';

import '../proto/chibre.pb.dart' as pb;
import 'basic_codec.dart';

pb.Action encodeAction(GameAction action) => switch (action) {
      ChooseTrump(:final mode) => pb.Action(
          seat: action.seat,
          chooseTrump: pb.ChooseTrump(mode: encodeMode(mode)),
        ),
      Chibrer() => pb.Action(seat: action.seat, chibrer: pb.Chibrer()),
      PlayCard(:final card, :final melds, :final stoeck) => pb.Action(
          seat: action.seat,
          playCard: pb.PlayCard(
            card: card.index,
            melds: [for (final meld in melds) encodeCards(meld.cards)],
            stoeck: stoeck,
          ),
        ),
    };

GameAction decodeAction(pb.Action action) => switch (action.whichKind()) {
      pb.Action_Kind.chooseTrump => ChooseTrump(
          action.seat,
          decodeMode(action.chooseTrump.mode) ??
              (throw const FormatException('Missing trump mode')),
        ),
      pb.Action_Kind.chibrer => Chibrer(action.seat),
      pb.Action_Kind.playCard => PlayCard(
          action.seat,
          Card.fromIndex(action.playCard.card),
          melds: [for (final bits in action.playCard.melds) decodeMeld(bits)],
          stoeck: action.playCard.stoeck,
        ),
      pb.Action_Kind.notSet => throw const FormatException('Empty action'),
    };
