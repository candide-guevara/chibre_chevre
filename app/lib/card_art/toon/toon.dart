import 'dart:ui';

import 'package:chibre_core/chibre_core.dart';

/// The animals of the face cards.
enum Animal { cow, dog, monkey, zebra }

enum Side { l, r }

enum HandPose { open, limp, fist, grip, hip, point }

enum ShoeKind { round, heel, boot }

enum Prop { scepter, fan, halberd, rose, mirror }

enum Sleeve { main, skin }

enum Outfit { king, queen, jack }

enum Hat { crown, tiara, pillbox, feather }

enum Expression { smug, sly, sultry, grin, proud }

/// One arm: the curve from the shoulder to the wrist and what the hand does.
class Arm {
  const Arm({
    required this.path,
    this.hand = HandPose.open,
    this.angle,
    this.thumb,
    this.prop,
    this.propUnder = false,
    this.top,
    this.below,
    this.flagSide,
    this.stem,
    this.fanDir,
    this.spread,
    this.sleeve,
    this.behind = false,
  });

  final List<Offset> path;
  final HandPose hand;

  /// Direction of the fingers in degrees; along the forearm when null.
  final double? angle;

  /// Side the thumb sits on (1 or -1).
  final int? thumb;
  final Prop? prop;

  /// Whether the prop goes behind the hand.
  final bool propUnder;

  /// The top of a scepter or halberd.
  final Offset? top;

  /// How far a halberd pole goes below the hand.
  final double? below;
  final int? flagSide;

  /// Angle (radians) of a rose or mirror stem from the hand direction.
  final double? stem;
  final double? fanDir;
  final double? spread;
  final Sleeve? sleeve;

  /// Drawn behind the body.
  final bool behind;

  Arm copyWith({
    List<Offset>? path,
    double? angle,
    int? thumb,
    Offset? top,
    int? flagSide,
    double? stem,
    double? fanDir,
  }) => Arm(
    path: path ?? this.path,
    hand: hand,
    angle: angle ?? this.angle,
    thumb: thumb ?? this.thumb,
    prop: prop,
    propUnder: propUnder,
    top: top ?? this.top,
    below: below,
    flagSide: flagSide ?? this.flagSide,
    stem: stem ?? this.stem,
    fanDir: fanDir ?? this.fanDir,
    spread: spread,
    sleeve: sleeve,
    behind: behind,
  );
}

class Leg {
  const Leg({required this.path, this.facing, this.tilt = 0});

  final List<Offset> path;

  /// Which way the shoe points (1 right, -1 left).
  final int? facing;
  final double tilt;
}

class Skirt {
  const Skirt({
    required this.hem,
    required this.width,
    this.sway = 0,
    this.flare = 1,
    this.folds = 3,
  });

  final double hem, width, sway, flare;
  final int folds;
}

/// Where everything goes, in a 400×600 box.
class Pose {
  const Pose({
    required this.head,
    this.tilt = 0,
    this.face = 1,
    this.hatTilt = 0,
    this.hatX = 0,
    required this.chest,
    required this.waist,
    required this.hip,
    required this.widths,
    this.shoulderTilt = 0,
    this.capeHem = 470,
    this.capeSway = 0,
    this.skirt,
    required this.arms,
    required this.legs,
    this.legOrder = const [Side.l, Side.r],
    this.tail,
  });

  final Offset head;

  /// Head tilt in degrees.
  final double tilt;

  /// Which way the snout points (1 right, -1 left).
  final int face;
  final double hatTilt, hatX;
  final Offset chest, waist, hip;

  /// Chest, waist and hip widths.
  final (double, double, double) widths;
  final double shoulderTilt, capeHem, capeSway;
  final Skirt? skirt;
  final Map<Side, Arm> arms;
  final Map<Side, Leg> legs;
  final List<Side> legOrder;
  final List<Offset>? tail;

  Pose withArm(Side side, Arm arm) => Pose(
    head: head,
    tilt: tilt,
    face: face,
    hatTilt: hatTilt,
    hatX: hatX,
    chest: chest,
    waist: waist,
    hip: hip,
    widths: widths,
    shoulderTilt: shoulderTilt,
    capeHem: capeHem,
    capeSway: capeSway,
    skirt: skirt,
    arms: {...arms, side: arm},
    legs: legs,
    legOrder: legOrder,
    tail: tail,
  );
}

/// The costume colours of a suit.
class Costume {
  const Costume({
    required this.main,
    required this.trim,
    required this.light,
    required this.pants,
    required this.shoe,
    required this.suit,
  });

  final Color main, trim, light, pants, shoe;

  /// The colour of the suit symbols.
  final Color suit;
}

/// A face card character.
class Toon {
  const Toon({
    required this.animal,
    required this.pose,
    required this.fur,
    required this.fur2,
    required this.face,
    required this.outfit,
    required this.costume,
    required this.suit,
    this.legColor,
    required this.shoeKind,
    required this.shoeColor,
    this.shoeAccent,
    required this.hat,
    required this.expression,
    this.lookDir = const Offset(0.3, 0),
    this.lashes = 0,
    this.lips,
  });

  final Animal animal;
  final Pose pose;

  /// Main fur, markings (spots, stripes, tan) and muzzle or mask.
  final Color fur, fur2, face;
  final Outfit outfit;
  final Costume costume;
  final Suit suit;

  /// Trousers or stockings; bare fur when null.
  final Color? legColor;
  final ShoeKind shoeKind;
  final Color shoeColor;
  final Color? shoeAccent;
  final Hat hat;
  final Expression expression;
  final Offset lookDir;
  final int lashes;
  final Color? lips;
}
