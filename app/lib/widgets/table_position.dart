import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/widgets.dart';

/// Where a seat sits on screen, seen from the viewer (always at the bottom).
/// Play is counter-clockwise, so the next seat is on the right.
enum TablePosition {
  bottom(Alignment.bottomCenter),
  right(Alignment.centerRight),
  top(Alignment.topCenter),
  left(Alignment.centerLeft);

  const TablePosition(this.alignment);

  /// Where the seat's card goes in a trick.
  final Alignment alignment;

  /// From the center of the table towards the seat.
  Offset get direction => Offset(alignment.x, alignment.y);
}

TablePosition positionOf(int seat, int viewer) =>
    TablePosition.values[(seat - viewer) % seatCount];
