import '../proto/chibre.pb.dart' as pb;
import '../transport/game_listing.dart';

pb.GameAdvert encodeListing(GameListing listing, {required int port}) =>
    pb.GameAdvert(
      protocolVersion: pb.ProtocolVersion.PROTOCOL_VERSION_CURRENT.value,
      gameId: listing.gameId,
      name: listing.name,
      hostNickname: listing.hostNickname,
      port: port,
      reservedFor: listing.reservedFor ?? '',
      scores: listing.scores,
    );

GameListing decodeListing(pb.GameAdvert advert) => GameListing(
      gameId: advert.gameId,
      name: advert.name,
      hostNickname: advert.hostNickname,
      reservedFor: advert.reservedFor.isEmpty ? null : advert.reservedFor,
      scores: List.unmodifiable(advert.scores),
    );
