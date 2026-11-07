import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'playing_card.dart';

/// Where a seat sits on screen, seen from [viewer] (always at the bottom).
/// Play is counter-clockwise, so the next seat is on the right.
enum TablePosition { bottom, right, top, left }

TablePosition positionOf(int seat, int viewer) =>
    TablePosition.values[(seat - viewer) % seatCount];

/// The cards of a trick, each in front of the seat that played it. Once the
/// trick is complete, the cards slide towards its [winner].
class TrickView extends StatefulWidget {
  const TrickView({
    super.key,
    required this.trick,
    required this.viewer,
    required this.style,
    required this.cardWidth,
    required this.hold,
    this.winner,
  });

  final Trick trick;
  final int viewer;
  final CardStyle style;
  final double cardWidth;

  /// How long the complete trick stays before sliding to its winner.
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
    await Future<void>.delayed(widget.hold);
    if (mounted && generation == _generation) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset get _direction => switch (widget.winner == null
      ? null
      : positionOf(widget.winner!, widget.viewer)) {
    TablePosition.bottom => const Offset(0, 1),
    TablePosition.right => const Offset(1, 0),
    TablePosition.top => const Offset(0, -1),
    TablePosition.left => const Offset(-1, 0),
    null => Offset.zero,
  };

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
        width: width * 3.2,
        height: height * 2.3,
        child: Stack(
          children: [
            for (final (position, card) in widget.trick.cards.indexed)
              Align(
                alignment: switch (positionOf(
                  widget.trick.seatAt(position),
                  widget.viewer,
                )) {
                  TablePosition.bottom => Alignment.bottomCenter,
                  TablePosition.right => Alignment.centerRight,
                  TablePosition.top => Alignment.topCenter,
                  TablePosition.left => Alignment.centerLeft,
                },
                child: PlayingCard(
                  card: card,
                  style: widget.style,
                  width: width,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
