import 'card_set.dart';

/// Provides the hands of each new round.
abstract interface class DealSource {
  /// The four hands of the next round, indexed by seat.
  List<CardSet> nextDeal();
}
