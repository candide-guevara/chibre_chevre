import 'card_set.dart';
import 'deal_source.dart';
import 'random_deal_source.dart';

/// Replays the deals of a previous game (rematch with the same cards), then
/// continues with [fallback] if the new game lasts longer.
class ReplayDealSource implements DealSource {
  ReplayDealSource(List<List<CardSet>> deals, {DealSource? fallback})
      : _deals = List.of(deals),
        _fallback = fallback ?? RandomDealSource();

  final List<List<CardSet>> _deals;
  final DealSource _fallback;
  var _next = 0;

  @override
  List<CardSet> nextDeal() =>
      _next < _deals.length ? _deals[_next++] : _fallback.nextDeal();
}
