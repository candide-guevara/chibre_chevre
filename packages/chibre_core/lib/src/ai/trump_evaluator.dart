import 'dart:math';

import '../engine/card.dart';
import '../engine/card_set.dart';
import '../engine/deal.dart';
import '../engine/player_view.dart';
import '../engine/seat.dart';
import '../engine/stoeck.dart';
import '../engine/trump_mode.dart';
import 'heuristic_policy.dart';
import 'playout.dart';
import 'trump_heuristic.dart';
import 'trump_option.dart';

/// Estimates the value of each trump option by dealing the unseen cards at
/// random and playing the rounds out with the heuristic policy. The same
/// deals are used for every option so they are compared fairly.
///
/// Values are the expected advantage of the player's team (half the point
/// difference, multiplier included).
class TrumpEvaluator {
  TrumpEvaluator({required this.samples, Random? random})
      : _random = random ?? Random();

  final int samples;
  final Random _random;

  Map<TrumpOption, double> evaluate(PlayerView view) {
    final team = teamOf(view.seat);
    final allowed = view.options.allowedModes;
    final canChibrer = !view.chibred;
    final totals = <TrumpOption, double>{
      for (final mode in allowed) TrumpOption.mode(mode): 0,
      if (canChibrer) const TrumpOption.chibrer(): 0,
    };
    final unseen = (CardSet.full - view.hand).cards;
    for (var i = 0; i < samples; i++) {
      final hands = _deal(view.seat, view.hand, unseen);
      for (final mode in allowed) {
        totals[TrumpOption.mode(mode)] =
            totals[TrumpOption.mode(mode)]! + _play(view, hands, mode, team);
      }
      if (canChibrer) {
        final partnerMode =
            bestHeuristicMode(hands[partnerOf(view.seat)], allowed);
        totals[const TrumpOption.chibrer()] =
            totals[const TrumpOption.chibrer()]! +
                _play(view, hands, partnerMode, team);
      }
    }
    return totals.map((option, total) => MapEntry(option, total / samples));
  }

  List<CardSet> _deal(int seat, CardSet hand, List<Card> unseen) {
    final cards = List.of(unseen)..shuffle(_random);
    final hands = List.filled(seatCount, hand);
    var next = 0;
    for (var other = 0; other < seatCount; other++) {
      if (other == seat) continue;
      hands[other] = CardSet.of(cards.sublist(next, next + handSize));
      next += handSize;
    }
    return hands;
  }

  double _play(PlayerView view, List<CardSet> hands, TrumpMode mode, int team) {
    final playout = Playout.newRound(hands, mode, view.trumpChooser);
    while (!playout.isOver) {
      final seat = playout.seatToAct;
      playout.play(heuristicCard(
          playout.hands[seat], playout.trick, mode, playout.unplayed));
    }
    var advantage = playout.advantage(team);
    for (var seat = 0; seat < seatCount; seat++) {
      if (holdsStoeck(hands[seat], mode)) {
        advantage += (teamOf(seat) == team ? stoeckPoints : -stoeckPoints) / 2;
      }
    }
    return advantage * view.options.multiplierFor(mode);
  }
}
