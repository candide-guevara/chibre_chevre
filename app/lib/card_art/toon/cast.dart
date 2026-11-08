import 'dart:math';
import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

import 'figure.dart';
import 'toon.dart';

/// One animal per suit.
Animal animalOf(Suit suit) => switch (suit) {
  Suit.hearts => Animal.cow,
  Suit.spades => Animal.dog,
  Suit.diamonds => Animal.monkey,
  Suit.clubs => Animal.zebra,
};

/// Main fur, markings and muzzle (or mask) of each animal.
const _fur = {
  Animal.cow: (Color(0xFFFBF6EA), Color(0xFF2A211D), Color(0xFFF4A7A3)),
  Animal.dog: (Color(0xFF4A4152), Color(0xFFC06A2E), Color(0xFFF7F1E4)),
  Animal.monkey: (Color(0xFF7A4A2A), Color(0xFF4C2A16), Color(0xFFF2C9A0)),
  Animal.zebra: (Color(0xFFFBF8F0), Color(0xFF1B1B22), Color(0xFF2E2B33)),
};

/// The character of a jack, queen or king of [suit] dressed in [costume].
Toon castToon(Rank rank, Suit suit, Costume costume) {
  final animal = animalOf(suit);
  var pose = _poses[(animal, rank)]!();
  if (rank == Rank.jack) pose = pose.withArm(Side.l, _flagArm(pose));
  final (fur, fur2, face) = _fur[animal]!;
  Toon toon({
    required Outfit outfit,
    required Hat hat,
    required Expression expression,
    required ShoeKind shoeKind,
    required Color shoeColor,
    Color? shoeAccent,
    Color? legColor,
    required Offset lookDir,
    int lashes = 0,
    Color? lips,
  }) => Toon(
    animal: animal,
    pose: pose,
    fur: fur,
    fur2: fur2,
    face: face,
    outfit: outfit,
    costume: costume,
    suit: suit,
    legColor: legColor,
    shoeKind: shoeKind,
    shoeColor: shoeColor,
    shoeAccent: shoeAccent,
    hat: hat,
    expression: expression,
    lookDir: lookDir,
    lashes: lashes,
    lips: lips,
  );
  return switch (rank) {
    Rank.king => toon(
      outfit: Outfit.king,
      hat: Hat.crown,
      expression: Expression.proud,
      legColor: costume.pants,
      shoeKind: ShoeKind.boot,
      shoeColor: costume.shoe,
      shoeAccent: costume.trim,
      lookDir: const Offset(0.35, -0.1),
    ),
    Rank.queen => toon(
      outfit: Outfit.queen,
      hat: Hat.tiara,
      expression: Expression.sultry,
      lashes: 3,
      lips: const Color(0xFFD42A4A),
      shoeKind: ShoeKind.heel,
      shoeColor: costume.main,
      shoeAccent: costume.trim,
      lookDir: const Offset(0.4, 0),
    ),
    _ => toon(
      outfit: Outfit.jack,
      hat: animal == Animal.monkey ? Hat.feather : Hat.pillbox,
      expression: animal == Animal.monkey ? Expression.grin : Expression.sly,
      legColor: costume.pants,
      shoeKind: ShoeKind.round,
      shoeColor: costume.shoe,
      lookDir: const Offset(0.45, -0.05),
    ),
  };
}

/// Every jack carries the same flag on the left, held the same way.
Arm _flagArm(Pose pose) {
  final from = shoulder(pose, Side.l);
  const wrist = Offset(136, 310);
  return Arm(
    path: [
      Offset(min(from.dx, wrist.dx) - 10, (from.dy + wrist.dy) / 2),
      wrist,
    ],
    hand: HandPose.grip,
    angle: 0,
    thumb: 1,
    prop: Prop.halberd,
    propUnder: true,
    top: const Offset(110, 40),
    below: 200,
    flagSide: 1,
    sleeve: Sleeve.main,
  );
}

/// The pose seen in a mirror: left and right swap.
Pose _mirror(Pose p) {
  Offset fx(Offset o) => Offset(400 - o.dx, o.dy);
  Side swap(Side s) => s == Side.l ? Side.r : Side.l;
  final skirt = p.skirt;
  return Pose(
    head: fx(p.head),
    tilt: -p.tilt,
    face: -p.face,
    hatTilt: -p.hatTilt,
    hatX: -p.hatX,
    chest: fx(p.chest),
    waist: fx(p.waist),
    hip: fx(p.hip),
    widths: p.widths,
    shoulderTilt: -p.shoulderTilt,
    capeHem: p.capeHem,
    capeSway: -p.capeSway,
    skirt: skirt == null
        ? null
        : Skirt(
            hem: skirt.hem,
            width: skirt.width,
            sway: -skirt.sway,
            flare: skirt.flare,
            folds: skirt.folds,
          ),
    arms: {
      for (final MapEntry(key: side, value: a) in p.arms.entries)
        swap(side): a.copyWith(
          path: [for (final o in a.path) fx(o)],
          angle: a.angle == null ? null : 180 - a.angle!,
          thumb: -(a.thumb ?? (side == Side.r ? 1 : -1)),
          top: a.top == null ? null : fx(a.top!),
          stem: a.stem == null ? null : -a.stem!,
          flagSide: a.prop == Prop.halberd ? -(a.flagSide ?? 1) : null,
          fanDir: a.fanDir == null ? null : 180 - a.fanDir!,
        ),
    },
    legs: {
      for (final MapEntry(key: side, value: l) in p.legs.entries)
        swap(side): Leg(
          path: [for (final o in l.path) fx(o)],
          facing: -(l.facing ?? (side == Side.r ? 1 : -1)),
          tilt: l.tilt,
        ),
    },
    legOrder: [for (final s in p.legOrder) swap(s)],
    tail: p.tail == null ? null : [for (final o in p.tail!) fx(o)],
  );
}

final Map<(Animal, Rank), Pose Function()> _poses = {
  (Animal.cow, Rank.king): () => _cowKing,
  (Animal.cow, Rank.queen): () => _cowQueen,
  (Animal.cow, Rank.jack): () => _mirror(_cowJack),
  (Animal.dog, Rank.king): () => _dogKing,
  (Animal.dog, Rank.queen): () => _dogQueen,
  (Animal.dog, Rank.jack): () => _dogJack,
  (Animal.monkey, Rank.king): () => _mirror(_monkeyKing),
  (Animal.monkey, Rank.queen): () => _monkeyQueen,
  (Animal.monkey, Rank.jack): () => _mirror(_monkeyJack),
  (Animal.zebra, Rank.king): () => _zebraKing,
  (Animal.zebra, Rank.queen): () => _zebraQueen,
  (Animal.zebra, Rank.jack): () => _mirror(_zebraJack),
};

const _cowKing = Pose(
  head: Offset(228, 120),
  tilt: 9,
  face: -1,
  hatTilt: -12,
  chest: Offset(214, 222),
  waist: Offset(202, 276),
  hip: Offset(194, 316),
  widths: (68, 40, 52),
  shoulderTilt: 6,
  capeHem: 505,
  capeSway: -18,
  arms: {
    Side.l: Arm(
      path: [Offset(150, 236), Offset(128, 222), Offset(112, 190)],
      hand: HandPose.open,
      angle: -110,
      sleeve: Sleeve.main,
    ),
    Side.r: Arm(
      path: [Offset(268, 252), Offset(276, 280), Offset(276, 304)],
      hand: HandPose.grip,
      angle: 180,
      thumb: -1,
      prop: Prop.scepter,
      propUnder: true,
      top: Offset(300, 120),
      sleeve: Sleeve.main,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(166, 400), Offset(160, 470), Offset(150, 526)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(222, 400), Offset(238, 470), Offset(246, 526)],
      facing: 1,
    ),
  },
  tail: [Offset(152, 344), Offset(124, 380), Offset(118, 432)],
);

const _cowQueen = Pose(
  head: Offset(198, 120),
  tilt: -13,
  face: -1,
  chest: Offset(188, 220),
  waist: Offset(202, 270),
  hip: Offset(220, 310),
  widths: (66, 28, 62),
  shoulderTilt: -8,
  skirt: Skirt(hem: 440, width: 100, sway: 18, flare: 1.25),
  arms: {
    Side.l: Arm(
      path: [Offset(132, 248), Offset(138, 284), Offset(176, 296)],
      hand: HandPose.hip,
      angle: 20,
      thumb: 1,
      sleeve: Sleeve.skin,
    ),
    Side.r: Arm(
      path: [Offset(254, 222), Offset(270, 190), Offset(252, 160)],
      hand: HandPose.grip,
      angle: -120,
      prop: Prop.fan,
      fanDir: -50,
      spread: 140,
      sleeve: Sleeve.skin,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(212, 400), Offset(222, 460), Offset(244, 520)],
      facing: 1,
      tilt: 0.2,
    ),
    Side.r: Leg(
      path: [Offset(236, 400), Offset(234, 460), Offset(224, 524)],
      facing: 1,
    ),
  },
  legOrder: [Side.r, Side.l],
  tail: [Offset(258, 340), Offset(296, 366), Offset(304, 420)],
);

const _cowJack = Pose(
  head: Offset(196, 124),
  tilt: 8,
  face: -1,
  hatTilt: 16,
  chest: Offset(212, 224),
  waist: Offset(204, 276),
  hip: Offset(198, 314),
  widths: (56, 36, 46),
  shoulderTilt: 6,
  arms: {
    Side.l: Arm(
      path: [Offset(152, 256), Offset(128, 290), Offset(110, 320)],
      hand: HandPose.open,
      angle: 130,
      sleeve: Sleeve.main,
    ),
    Side.r: Arm(
      path: [Offset(266, 262), Offset(264, 246), Offset(250, 236)],
      sleeve: Sleeve.main,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(180, 400), Offset(176, 470), Offset(168, 526)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(246, 370), Offset(270, 420), Offset(282, 470)],
      facing: 1,
      tilt: -0.4,
    ),
  },
  tail: [Offset(156, 340), Offset(126, 360), Offset(114, 410)],
);

const _monkeyKing = Pose(
  head: Offset(188, 122),
  tilt: -9,
  face: -1,
  hatTilt: 14,
  chest: Offset(190, 222),
  waist: Offset(200, 276),
  hip: Offset(204, 316),
  widths: (64, 40, 50),
  shoulderTilt: -5,
  capeHem: 505,
  capeSway: 16,
  arms: {
    Side.l: Arm(
      path: [Offset(128, 256), Offset(122, 286), Offset(124, 306)],
      hand: HandPose.grip,
      angle: 0,
      thumb: 1,
      prop: Prop.scepter,
      propUnder: true,
      top: Offset(104, 116),
      sleeve: Sleeve.main,
    ),
    Side.r: Arm(
      path: [Offset(262, 250), Offset(262, 224), Offset(240, 206)],
      hand: HandPose.point,
      angle: -140,
      sleeve: Sleeve.main,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(190, 400), Offset(210, 460), Offset(232, 524)],
      facing: 1,
      tilt: 0.1,
    ),
    Side.r: Leg(
      path: [Offset(226, 400), Offset(204, 462), Offset(176, 526)],
      facing: -1,
    ),
  },
  legOrder: [Side.r, Side.l],
  tail: [
    Offset(256, 340),
    Offset(306, 346),
    Offset(322, 304),
    Offset(300, 282),
    Offset(290, 302),
  ],
);

const _monkeyQueen = Pose(
  head: Offset(222, 122),
  tilt: 12,
  face: -1,
  chest: Offset(208, 222),
  waist: Offset(196, 272),
  hip: Offset(184, 312),
  widths: (64, 28, 60),
  shoulderTilt: 7,
  skirt: Skirt(hem: 430, width: 94, sway: -16, flare: 1.3),
  arms: {
    Side.l: Arm(
      path: [Offset(144, 232), Offset(140, 196), Offset(156, 166)],
      hand: HandPose.grip,
      angle: -50,
      thumb: -1,
      prop: Prop.mirror,
      stem: -1.0,
      sleeve: Sleeve.skin,
    ),
    Side.r: Arm(
      path: [Offset(266, 250), Offset(262, 282), Offset(226, 294)],
      hand: HandPose.hip,
      angle: 160,
      thumb: -1,
      sleeve: Sleeve.skin,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(166, 400), Offset(170, 460), Offset(176, 524)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(186, 400), Offset(166, 456), Offset(148, 516)],
      facing: -1,
      tilt: 0.2,
    ),
  },
  tail: [
    Offset(150, 344),
    Offset(104, 344),
    Offset(92, 300),
    Offset(114, 280),
    Offset(122, 300),
  ],
);

const _monkeyJack = Pose(
  head: Offset(222, 126),
  tilt: 14,
  face: -1,
  hatTilt: -20,
  chest: Offset(204, 226),
  waist: Offset(194, 278),
  hip: Offset(190, 316),
  widths: (54, 34, 44),
  shoulderTilt: -10,
  arms: {
    Side.l: Arm(
      path: [Offset(140, 220), Offset(126, 190), Offset(126, 160)],
      hand: HandPose.open,
      angle: -90,
      sleeve: Sleeve.main,
    ),
    Side.r: Arm(
      path: [Offset(260, 270), Offset(270, 296), Offset(266, 312)],
      sleeve: Sleeve.main,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(146, 360), Offset(118, 400), Offset(92, 430)],
      facing: -1,
      tilt: -0.5,
    ),
    Side.r: Leg(
      path: [Offset(198, 400), Offset(212, 466), Offset(222, 526)],
      facing: 1,
    ),
  },
  tail: [
    Offset(226, 340),
    Offset(270, 368),
    Offset(262, 420),
    Offset(236, 412),
  ],
);

const _zebraKing = Pose(
  head: Offset(186, 116),
  tilt: 6,
  hatTilt: -8,
  chest: Offset(204, 226),
  waist: Offset(198, 280),
  hip: Offset(196, 320),
  widths: (66, 40, 52),
  shoulderTilt: 3,
  capeHem: 505,
  capeSway: -6,
  arms: {
    Side.l: Arm(
      path: [Offset(140, 262), Offset(122, 270), Offset(104, 256)],
      hand: HandPose.open,
      angle: 200,
      thumb: 1,
      sleeve: Sleeve.main,
    ),
    Side.r: Arm(
      path: [Offset(268, 262), Offset(286, 284), Offset(288, 300)],
      hand: HandPose.grip,
      angle: 180,
      thumb: -1,
      prop: Prop.scepter,
      propUnder: true,
      top: Offset(292, 112),
      sleeve: Sleeve.main,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(176, 400), Offset(172, 466), Offset(164, 526)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(214, 400), Offset(224, 466), Offset(234, 526)],
      facing: 1,
    ),
  },
  tail: [Offset(150, 344), Offset(128, 390), Offset(130, 440)],
);

const _zebraQueen = Pose(
  head: Offset(206, 116),
  tilt: -9,
  face: -1,
  chest: Offset(192, 224),
  waist: Offset(204, 274),
  hip: Offset(214, 314),
  widths: (64, 28, 60),
  shoulderTilt: -6,
  skirt: Skirt(hem: 522, width: 124, sway: 22, flare: 1.1, folds: 4),
  arms: {
    Side.l: Arm(
      path: [Offset(126, 230), Offset(110, 196), Offset(108, 160)],
      hand: HandPose.limp,
      angle: -120,
      thumb: -1,
      sleeve: Sleeve.skin,
    ),
    Side.r: Arm(
      path: [Offset(262, 262), Offset(268, 290), Offset(252, 310)],
      hand: HandPose.grip,
      angle: 130,
      prop: Prop.rose,
      stem: -2.2,
      sleeve: Sleeve.skin,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(208, 400), Offset(206, 466), Offset(204, 530)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(236, 400), Offset(244, 466), Offset(250, 530)],
      facing: 1,
    ),
  },
  tail: [Offset(262, 340), Offset(296, 386), Offset(292, 436)],
);

const _zebraJack = Pose(
  head: Offset(208, 122),
  tilt: -8,
  face: -1,
  hatTilt: 12,
  chest: Offset(198, 226),
  waist: Offset(204, 278),
  hip: Offset(206, 316),
  widths: (54, 34, 44),
  shoulderTilt: -4,
  arms: {
    Side.l: Arm(
      path: [Offset(130, 214), Offset(132, 140), Offset(166, 80)],
      hand: HandPose.open,
      angle: -10,
      thumb: 1,
      sleeve: Sleeve.main,
    ),
    Side.r: Arm(
      path: [Offset(250, 280), Offset(262, 298), Offset(264, 310)],
      sleeve: Sleeve.main,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(188, 400), Offset(174, 462), Offset(160, 524)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(224, 400), Offset(230, 462), Offset(226, 524)],
      facing: -1,
      tilt: 0.15,
    ),
  },
  tail: [Offset(154, 346), Offset(130, 386), Offset(134, 430)],
);

const _dogKing = Pose(
  head: Offset(214, 118),
  tilt: 4,
  face: -1,
  hatTilt: -6,
  chest: Offset(206, 224),
  waist: Offset(200, 278),
  hip: Offset(198, 318),
  widths: (66, 40, 52),
  shoulderTilt: -3,
  capeHem: 505,
  capeSway: -10,
  arms: {
    Side.l: Arm(
      path: [Offset(150, 262), Offset(126, 288), Offset(160, 304)],
      hand: HandPose.hip,
      angle: 20,
      thumb: 1,
      sleeve: Sleeve.main,
    ),
    Side.r: Arm(
      path: [Offset(262, 250), Offset(290, 226), Offset(296, 196)],
      hand: HandPose.grip,
      angle: -90,
      thumb: -1,
      prop: Prop.scepter,
      propUnder: true,
      top: Offset(300, 70),
      sleeve: Sleeve.main,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(178, 400), Offset(166, 466), Offset(150, 526)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(216, 400), Offset(232, 462), Offset(250, 522)],
      facing: 1,
    ),
  },
  tail: [Offset(250, 336), Offset(286, 330), Offset(300, 300)],
);

const _dogQueen = Pose(
  head: Offset(186, 118),
  tilt: -8,
  chest: Offset(194, 222),
  waist: Offset(204, 272),
  hip: Offset(212, 312),
  widths: (64, 28, 60),
  shoulderTilt: -6,
  skirt: Skirt(hem: 520, width: 120, sway: 14, flare: 1.15, folds: 4),
  arms: {
    Side.l: Arm(
      path: [Offset(140, 226), Offset(112, 180), Offset(136, 132)],
      hand: HandPose.limp,
      angle: 20,
      thumb: 1,
      sleeve: Sleeve.skin,
      behind: true,
    ),
    Side.r: Arm(
      path: [Offset(258, 250), Offset(274, 290), Offset(270, 326)],
      hand: HandPose.grip,
      angle: 90,
      prop: Prop.fan,
      fanDir: 50,
      spread: 120,
      sleeve: Sleeve.skin,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(200, 400), Offset(198, 466), Offset(196, 530)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(228, 400), Offset(238, 466), Offset(246, 530)],
      facing: 1,
    ),
  },
  tail: [Offset(254, 340), Offset(290, 330), Offset(300, 296)],
);

const _dogJack = Pose(
  head: Offset(204, 124),
  tilt: 8,
  hatTilt: -10,
  chest: Offset(204, 226),
  waist: Offset(198, 278),
  hip: Offset(196, 316),
  widths: (54, 34, 44),
  shoulderTilt: 5,
  arms: {
    Side.l: Arm(
      path: [Offset(150, 270), Offset(140, 296), Offset(138, 312)],
      sleeve: Sleeve.main,
    ),
    Side.r: Arm(
      path: [Offset(258, 222), Offset(282, 190), Offset(290, 150)],
      hand: HandPose.open,
      angle: -80,
      thumb: -1,
      sleeve: Sleeve.main,
    ),
  },
  legs: {
    Side.l: Leg(
      path: [Offset(178, 400), Offset(172, 466), Offset(160, 526)],
      facing: -1,
    ),
    Side.r: Leg(
      path: [Offset(214, 400), Offset(236, 456), Offset(258, 512)],
      facing: 1,
      tilt: -0.2,
    ),
  },
  tail: [Offset(240, 336), Offset(276, 320), Offset(284, 288)],
);
