// This is a generated file - do not edit.
//
// Generated from chibre.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Bump when a change breaks compatibility; mismatching phones refuse to play.
class ProtocolVersion extends $pb.ProtobufEnum {
  static const ProtocolVersion PROTOCOL_VERSION_UNSPECIFIED = ProtocolVersion._(
      0, _omitEnumNames ? '' : 'PROTOCOL_VERSION_UNSPECIFIED');
  static const ProtocolVersion PROTOCOL_VERSION_CURRENT =
      ProtocolVersion._(1, _omitEnumNames ? '' : 'PROTOCOL_VERSION_CURRENT');

  static const $core.List<ProtocolVersion> values = <ProtocolVersion>[
    PROTOCOL_VERSION_UNSPECIFIED,
    PROTOCOL_VERSION_CURRENT,
  ];

  static final $core.List<ProtocolVersion?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static ProtocolVersion? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProtocolVersion._(super.value, super.name);
}

class TrumpMode extends $pb.ProtobufEnum {
  static const TrumpMode TRUMP_MODE_NONE =
      TrumpMode._(0, _omitEnumNames ? '' : 'TRUMP_MODE_NONE');
  static const TrumpMode TRUMP_MODE_DIAMONDS =
      TrumpMode._(1, _omitEnumNames ? '' : 'TRUMP_MODE_DIAMONDS');
  static const TrumpMode TRUMP_MODE_HEARTS =
      TrumpMode._(2, _omitEnumNames ? '' : 'TRUMP_MODE_HEARTS');
  static const TrumpMode TRUMP_MODE_SPADES =
      TrumpMode._(3, _omitEnumNames ? '' : 'TRUMP_MODE_SPADES');
  static const TrumpMode TRUMP_MODE_CLUBS =
      TrumpMode._(4, _omitEnumNames ? '' : 'TRUMP_MODE_CLUBS');
  static const TrumpMode TRUMP_MODE_OBENABE =
      TrumpMode._(5, _omitEnumNames ? '' : 'TRUMP_MODE_OBENABE');
  static const TrumpMode TRUMP_MODE_UNDENUFE =
      TrumpMode._(6, _omitEnumNames ? '' : 'TRUMP_MODE_UNDENUFE');

  static const $core.List<TrumpMode> values = <TrumpMode>[
    TRUMP_MODE_NONE,
    TRUMP_MODE_DIAMONDS,
    TRUMP_MODE_HEARTS,
    TRUMP_MODE_SPADES,
    TRUMP_MODE_CLUBS,
    TRUMP_MODE_OBENABE,
    TRUMP_MODE_UNDENUFE,
  ];

  static final $core.List<TrumpMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static TrumpMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TrumpMode._(super.value, super.name);
}

class Rejected_Reason extends $pb.ProtobufEnum {
  static const Rejected_Reason REASON_UNSPECIFIED =
      Rejected_Reason._(0, _omitEnumNames ? '' : 'REASON_UNSPECIFIED');
  static const Rejected_Reason REASON_VERSION_MISMATCH =
      Rejected_Reason._(1, _omitEnumNames ? '' : 'REASON_VERSION_MISMATCH');
  static const Rejected_Reason REASON_GAME_FULL =
      Rejected_Reason._(2, _omitEnumNames ? '' : 'REASON_GAME_FULL');

  static const $core.List<Rejected_Reason> values = <Rejected_Reason>[
    REASON_UNSPECIFIED,
    REASON_VERSION_MISMATCH,
    REASON_GAME_FULL,
  ];

  static final $core.List<Rejected_Reason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Rejected_Reason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Rejected_Reason._(super.value, super.name);
}

class Blunder_Kind extends $pb.ProtobufEnum {
  static const Blunder_Kind KIND_TRUMP_CHOICE =
      Blunder_Kind._(0, _omitEnumNames ? '' : 'KIND_TRUMP_CHOICE');
  static const Blunder_Kind KIND_CARD_PLAY =
      Blunder_Kind._(1, _omitEnumNames ? '' : 'KIND_CARD_PLAY');
  static const Blunder_Kind KIND_MISSED_MELD =
      Blunder_Kind._(2, _omitEnumNames ? '' : 'KIND_MISSED_MELD');
  static const Blunder_Kind KIND_MISSED_STOECK =
      Blunder_Kind._(3, _omitEnumNames ? '' : 'KIND_MISSED_STOECK');

  static const $core.List<Blunder_Kind> values = <Blunder_Kind>[
    KIND_TRUMP_CHOICE,
    KIND_CARD_PLAY,
    KIND_MISSED_MELD,
    KIND_MISSED_STOECK,
  ];

  static final $core.List<Blunder_Kind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Blunder_Kind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Blunder_Kind._(super.value, super.name);
}

class TableSnapshot_Phase extends $pb.ProtobufEnum {
  static const TableSnapshot_Phase PHASE_WAITING_FOR_PLAYER =
      TableSnapshot_Phase._(
          0, _omitEnumNames ? '' : 'PHASE_WAITING_FOR_PLAYER');
  static const TableSnapshot_Phase PHASE_CHOOSING_TRUMP =
      TableSnapshot_Phase._(1, _omitEnumNames ? '' : 'PHASE_CHOOSING_TRUMP');
  static const TableSnapshot_Phase PHASE_PLAYING =
      TableSnapshot_Phase._(2, _omitEnumNames ? '' : 'PHASE_PLAYING');
  static const TableSnapshot_Phase PHASE_ROUND_OVER =
      TableSnapshot_Phase._(3, _omitEnumNames ? '' : 'PHASE_ROUND_OVER');
  static const TableSnapshot_Phase PHASE_GAME_OVER =
      TableSnapshot_Phase._(4, _omitEnumNames ? '' : 'PHASE_GAME_OVER');

  static const $core.List<TableSnapshot_Phase> values = <TableSnapshot_Phase>[
    PHASE_WAITING_FOR_PLAYER,
    PHASE_CHOOSING_TRUMP,
    PHASE_PLAYING,
    PHASE_ROUND_OVER,
    PHASE_GAME_OVER,
  ];

  static final $core.List<TableSnapshot_Phase?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TableSnapshot_Phase? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TableSnapshot_Phase._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
