import 'game_listing.dart';

/// A game found by discovery (or typed in by hand) that can be joined.
class OpenGame {
  const OpenGame({required this.listing, required this.address});

  final GameListing listing;

  /// Where to connect, in a form the transport understands.
  final String address;
}
