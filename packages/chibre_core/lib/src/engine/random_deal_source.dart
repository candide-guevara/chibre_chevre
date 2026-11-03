import 'dart:math';

import 'card_set.dart';
import 'deal.dart';
import 'deal_source.dart';

class RandomDealSource implements DealSource {
  RandomDealSource([Random? random]) : _random = random ?? Random();

  final Random _random;

  @override
  List<CardSet> nextDeal() => randomDeal(_random);
}
