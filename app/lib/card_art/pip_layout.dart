import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

const _left = 0.0, _middle = 0.5, _right = 1.0;

/// Where the suit symbols of number cards go, in a unit square (0 is the
/// top of the area, 1 the bottom). Symbols below the middle are drawn upside
/// down, as on traditional cards.
List<Offset> pipPositions(Rank rank) {
  const sixes = [
    Offset(_left, 0), Offset(_right, 0), //
    Offset(_left, 0.5), Offset(_right, 0.5), //
    Offset(_left, 1), Offset(_right, 1),
  ];
  const eights = [
    Offset(_left, 0), Offset(_right, 0), //
    Offset(_left, 1 / 3), Offset(_right, 1 / 3), //
    Offset(_left, 2 / 3), Offset(_right, 2 / 3), //
    Offset(_left, 1), Offset(_right, 1),
  ];
  return switch (rank) {
    Rank.six => sixes,
    Rank.seven => [...sixes, const Offset(_middle, 0.25)],
    Rank.eight => [
      ...sixes,
      const Offset(_middle, 0.25),
      const Offset(_middle, 0.75),
    ],
    Rank.nine => [...eights, const Offset(_middle, 0.5)],
    Rank.ten => [
      ...eights,
      const Offset(_middle, 1 / 6),
      const Offset(_middle, 5 / 6),
    ],
    _ => const [],
  };
}
