import 'dart:math' as math;

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'played_card.dart';
import 'playing_card.dart';
import 'table_position.dart';

/// The cards of a trick, each in front of the seat that played it. Once the
/// trick is complete, the cards slide towards its [winner].
class TrickView extends StatefulWidget {
  const TrickView({
    super.key,
    required this.trick,
    required this.viewer,
    required this.cardWidth,
    required this.hold,
    this.winner,
  });

  /// The size of the trick, in card widths.
  static const _widthInCards = 3.2, _heightInCards = 2.3 * cardAspectRatio;

  /// The widest cards for a trick that fits in [space], up to the size of
  /// the cards in the hand.
  static double cardWidthIn(Size space) => math
      .min(space.width / _widthInCards, space.height / _heightInCards)
      .clamp(36.0, maxCardWidth);

  final Trick trick;
  final int viewer;
  final double cardWidth;

  /// How long the complete trick stays, once its last card is in place,
  /// before sliding to its winner.
  final Duration hold;

  /// The seat that won the trick, once it is complete.
  final int? winner;

  @override
  State<TrickView> createState() => _TrickViewState();
}

class _TrickViewState extends State<TrickView>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const SessionTiming().trickSlide,
  );

  /// Bumped whenever another trick is shown, to drop pending collections.
  var _generation = 0;
  late final _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    _collectIfWon();
  }

  @override
  void didUpdateWidget(TrickView old) {
    super.didUpdateWidget(old);
    final sameTrick =
        old.trick.leader == widget.trick.leader &&
        listEquals(old.trick.cards, widget.trick.cards);
    if (sameTrick && old.winner == widget.winner) return;
    _generation++;
    _controller.reset();
    _collectIfWon();
  }

  Future<void> _collectIfWon() async {
    if (widget.winner == null) return;
    final generation = _generation;
    await Future<void>.delayed(const SessionTiming().cardSlide + widget.hold);
    if (mounted && generation == _generation) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset get _direction => widget.winner == null
      ? Offset.zero
      : positionOf(widget.winner!, widget.viewer).direction;

  @override
  Widget build(BuildContext context) {
    final width = widget.cardWidth;
    final height = width * cardAspectRatio;
    final distance = Offset(width * 3, height * 1.6);
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) => Opacity(
        opacity: 1 - _progress.value,
        child: Transform.translate(
          offset:
              Offset(_direction.dx * distance.dx, _direction.dy * distance.dy) *
              _progress.value,
          child: Transform.scale(
            scale: 1 - 0.4 * _progress.value,
            child: child,
          ),
        ),
      ),
      child: SizedBox(
        width: width * TrickView._widthInCards,
        height: width * TrickView._heightInCards,
        child: Stack(
          children: [
            for (final (index, card) in widget.trick.cards.indexed)
              _place(
                card,
                positionOf(widget.trick.seatAt(index), widget.viewer),
              ),
          ],
        ),
      ),
    );
  }

  Widget _place(Card card, TablePosition position) => Align(
    alignment: position.alignment,
    child: PlayedCard(
      // Keyed so that only newly played cards slide in.
      key: ValueKey(card),
      card: card,
      width: widget.cardWidth,
      from: position,
    ),
  );
}
