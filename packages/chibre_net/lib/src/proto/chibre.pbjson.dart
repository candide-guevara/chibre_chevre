// This is a generated file - do not edit.
//
// Generated from chibre.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use protocolVersionDescriptor instead')
const ProtocolVersion$json = {
  '1': 'ProtocolVersion',
  '2': [
    {'1': 'PROTOCOL_VERSION_UNSPECIFIED', '2': 0},
    {'1': 'PROTOCOL_VERSION_CURRENT', '2': 1},
  ],
};

/// Descriptor for `ProtocolVersion`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List protocolVersionDescriptor = $convert.base64Decode(
    'Cg9Qcm90b2NvbFZlcnNpb24SIAocUFJPVE9DT0xfVkVSU0lPTl9VTlNQRUNJRklFRBAAEhwKGF'
    'BST1RPQ09MX1ZFUlNJT05fQ1VSUkVOVBAB');

@$core.Deprecated('Use trumpModeDescriptor instead')
const TrumpMode$json = {
  '1': 'TrumpMode',
  '2': [
    {'1': 'TRUMP_MODE_NONE', '2': 0},
    {'1': 'TRUMP_MODE_DIAMONDS', '2': 1},
    {'1': 'TRUMP_MODE_HEARTS', '2': 2},
    {'1': 'TRUMP_MODE_SPADES', '2': 3},
    {'1': 'TRUMP_MODE_CLUBS', '2': 4},
    {'1': 'TRUMP_MODE_OBENABE', '2': 5},
    {'1': 'TRUMP_MODE_UNDENUFE', '2': 6},
  ],
};

/// Descriptor for `TrumpMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trumpModeDescriptor = $convert.base64Decode(
    'CglUcnVtcE1vZGUSEwoPVFJVTVBfTU9ERV9OT05FEAASFwoTVFJVTVBfTU9ERV9ESUFNT05EUx'
    'ABEhUKEVRSVU1QX01PREVfSEVBUlRTEAISFQoRVFJVTVBfTU9ERV9TUEFERVMQAxIUChBUUlVN'
    'UF9NT0RFX0NMVUJTEAQSFgoSVFJVTVBfTU9ERV9PQkVOQUJFEAUSFwoTVFJVTVBfTU9ERV9VTk'
    'RFTlVGRRAG');

@$core.Deprecated('Use gameOptionsDescriptor instead')
const GameOptions$json = {
  '1': 'GameOptions',
  '2': [
    {'1': 'target_score', '3': 1, '4': 1, '5': 13, '10': 'targetScore'},
    {'1': 'oben_unde_allowed', '3': 2, '4': 1, '5': 8, '10': 'obenUndeAllowed'},
    {
      '1': 'multipliers_enabled',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'multipliersEnabled'
    },
  ],
};

/// Descriptor for `GameOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameOptionsDescriptor = $convert.base64Decode(
    'CgtHYW1lT3B0aW9ucxIhCgx0YXJnZXRfc2NvcmUYASABKA1SC3RhcmdldFNjb3JlEioKEW9iZW'
    '5fdW5kZV9hbGxvd2VkGAIgASgIUg9vYmVuVW5kZUFsbG93ZWQSLwoTbXVsdGlwbGllcnNfZW5h'
    'YmxlZBgDIAEoCFISbXVsdGlwbGllcnNFbmFibGVk');

@$core.Deprecated('Use gameAdvertDescriptor instead')
const GameAdvert$json = {
  '1': 'GameAdvert',
  '2': [
    {'1': 'protocol_version', '3': 1, '4': 1, '5': 13, '10': 'protocolVersion'},
    {'1': 'game_id', '3': 2, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'host_nickname', '3': 4, '4': 1, '5': 9, '10': 'hostNickname'},
    {'1': 'port', '3': 5, '4': 1, '5': 13, '10': 'port'},
    {'1': 'reserved_for', '3': 6, '4': 1, '5': 9, '10': 'reservedFor'},
    {'1': 'scores', '3': 7, '4': 3, '5': 5, '10': 'scores'},
  ],
};

/// Descriptor for `GameAdvert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameAdvertDescriptor = $convert.base64Decode(
    'CgpHYW1lQWR2ZXJ0EikKEHByb3RvY29sX3ZlcnNpb24YASABKA1SD3Byb3RvY29sVmVyc2lvbh'
    'IXCgdnYW1lX2lkGAIgASgJUgZnYW1lSWQSEgoEbmFtZRgDIAEoCVIEbmFtZRIjCg1ob3N0X25p'
    'Y2tuYW1lGAQgASgJUgxob3N0Tmlja25hbWUSEgoEcG9ydBgFIAEoDVIEcG9ydBIhCgxyZXNlcn'
    'ZlZF9mb3IYBiABKAlSC3Jlc2VydmVkRm9yEhYKBnNjb3JlcxgHIAMoBVIGc2NvcmVz');

@$core.Deprecated('Use chooseTrumpDescriptor instead')
const ChooseTrump$json = {
  '1': 'ChooseTrump',
  '2': [
    {
      '1': 'mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.chibre.TrumpMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `ChooseTrump`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chooseTrumpDescriptor = $convert.base64Decode(
    'CgtDaG9vc2VUcnVtcBIlCgRtb2RlGAEgASgOMhEuY2hpYnJlLlRydW1wTW9kZVIEbW9kZQ==');

@$core.Deprecated('Use chibrerDescriptor instead')
const Chibrer$json = {
  '1': 'Chibrer',
};

/// Descriptor for `Chibrer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chibrerDescriptor =
    $convert.base64Decode('CgdDaGlicmVy');

@$core.Deprecated('Use playCardDescriptor instead')
const PlayCard$json = {
  '1': 'PlayCard',
  '2': [
    {'1': 'card', '3': 1, '4': 1, '5': 13, '10': 'card'},
    {'1': 'melds', '3': 2, '4': 3, '5': 4, '10': 'melds'},
    {'1': 'stoeck', '3': 3, '4': 1, '5': 8, '10': 'stoeck'},
  ],
};

/// Descriptor for `PlayCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playCardDescriptor = $convert.base64Decode(
    'CghQbGF5Q2FyZBISCgRjYXJkGAEgASgNUgRjYXJkEhQKBW1lbGRzGAIgAygEUgVtZWxkcxIWCg'
    'ZzdG9lY2sYAyABKAhSBnN0b2Vjaw==');

@$core.Deprecated('Use actionDescriptor instead')
const Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'seat', '3': 1, '4': 1, '5': 13, '10': 'seat'},
    {
      '1': 'choose_trump',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.chibre.ChooseTrump',
      '9': 0,
      '10': 'chooseTrump'
    },
    {
      '1': 'chibrer',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.chibre.Chibrer',
      '9': 0,
      '10': 'chibrer'
    },
    {
      '1': 'play_card',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.chibre.PlayCard',
      '9': 0,
      '10': 'playCard'
    },
  ],
  '8': [
    {'1': 'kind'},
  ],
};

/// Descriptor for `Action`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionDescriptor = $convert.base64Decode(
    'CgZBY3Rpb24SEgoEc2VhdBgBIAEoDVIEc2VhdBI4CgxjaG9vc2VfdHJ1bXAYAiABKAsyEy5jaG'
    'licmUuQ2hvb3NlVHJ1bXBIAFILY2hvb3NlVHJ1bXASKwoHY2hpYnJlchgDIAEoCzIPLmNoaWJy'
    'ZS5DaGlicmVySABSB2NoaWJyZXISLwoJcGxheV9jYXJkGAQgASgLMhAuY2hpYnJlLlBsYXlDYX'
    'JkSABSCHBsYXlDYXJkQgYKBGtpbmQ=');

@$core.Deprecated('Use helloDescriptor instead')
const Hello$json = {
  '1': 'Hello',
  '2': [
    {'1': 'protocol_version', '3': 1, '4': 1, '5': 13, '10': 'protocolVersion'},
    {'1': 'installation_id', '3': 2, '4': 1, '5': 9, '10': 'installationId'},
    {'1': 'nickname', '3': 3, '4': 1, '5': 9, '10': 'nickname'},
  ],
};

/// Descriptor for `Hello`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloDescriptor = $convert.base64Decode(
    'CgVIZWxsbxIpChBwcm90b2NvbF92ZXJzaW9uGAEgASgNUg9wcm90b2NvbFZlcnNpb24SJwoPaW'
    '5zdGFsbGF0aW9uX2lkGAIgASgJUg5pbnN0YWxsYXRpb25JZBIaCghuaWNrbmFtZRgDIAEoCVII'
    'bmlja25hbWU=');

@$core.Deprecated('Use proposeRematchDescriptor instead')
const ProposeRematch$json = {
  '1': 'ProposeRematch',
  '2': [
    {'1': 'same_cards', '3': 1, '4': 1, '5': 8, '10': 'sameCards'},
  ],
};

/// Descriptor for `ProposeRematch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proposeRematchDescriptor = $convert.base64Decode(
    'Cg5Qcm9wb3NlUmVtYXRjaBIdCgpzYW1lX2NhcmRzGAEgASgIUglzYW1lQ2FyZHM=');

@$core.Deprecated('Use answerRematchDescriptor instead')
const AnswerRematch$json = {
  '1': 'AnswerRematch',
  '2': [
    {'1': 'accept', '3': 1, '4': 1, '5': 8, '10': 'accept'},
  ],
};

/// Descriptor for `AnswerRematch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List answerRematchDescriptor = $convert
    .base64Decode('Cg1BbnN3ZXJSZW1hdGNoEhYKBmFjY2VwdBgBIAEoCFIGYWNjZXB0');

@$core.Deprecated('Use presenceDescriptor instead')
const Presence$json = {
  '1': 'Presence',
  '2': [
    {'1': 'away', '3': 1, '4': 1, '5': 8, '10': 'away'},
  ],
};

/// Descriptor for `Presence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceDescriptor =
    $convert.base64Decode('CghQcmVzZW5jZRISCgRhd2F5GAEgASgIUgRhd2F5');

@$core.Deprecated('Use leaveDescriptor instead')
const Leave$json = {
  '1': 'Leave',
};

/// Descriptor for `Leave`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveDescriptor =
    $convert.base64Decode('CgVMZWF2ZQ==');

@$core.Deprecated('Use dismissRecapDescriptor instead')
const DismissRecap$json = {
  '1': 'DismissRecap',
};

/// Descriptor for `DismissRecap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissRecapDescriptor =
    $convert.base64Decode('CgxEaXNtaXNzUmVjYXA=');

@$core.Deprecated('Use meldsChosenDescriptor instead')
const MeldsChosen$json = {
  '1': 'MeldsChosen',
};

/// Descriptor for `MeldsChosen`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List meldsChosenDescriptor =
    $convert.base64Decode('CgtNZWxkc0Nob3Nlbg==');

@$core.Deprecated('Use clientMessageDescriptor instead')
const ClientMessage$json = {
  '1': 'ClientMessage',
  '2': [
    {
      '1': 'hello',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.chibre.Hello',
      '9': 0,
      '10': 'hello'
    },
    {
      '1': 'action',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.chibre.Action',
      '9': 0,
      '10': 'action'
    },
    {
      '1': 'propose_rematch',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.chibre.ProposeRematch',
      '9': 0,
      '10': 'proposeRematch'
    },
    {
      '1': 'answer_rematch',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.chibre.AnswerRematch',
      '9': 0,
      '10': 'answerRematch'
    },
    {
      '1': 'presence',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.chibre.Presence',
      '9': 0,
      '10': 'presence'
    },
    {
      '1': 'leave',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.chibre.Leave',
      '9': 0,
      '10': 'leave'
    },
    {
      '1': 'dismiss_recap',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.chibre.DismissRecap',
      '9': 0,
      '10': 'dismissRecap'
    },
    {
      '1': 'melds_chosen',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.chibre.MeldsChosen',
      '9': 0,
      '10': 'meldsChosen'
    },
  ],
  '8': [
    {'1': 'body'},
  ],
};

/// Descriptor for `ClientMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientMessageDescriptor = $convert.base64Decode(
    'Cg1DbGllbnRNZXNzYWdlEiUKBWhlbGxvGAEgASgLMg0uY2hpYnJlLkhlbGxvSABSBWhlbGxvEi'
    'gKBmFjdGlvbhgCIAEoCzIOLmNoaWJyZS5BY3Rpb25IAFIGYWN0aW9uEkEKD3Byb3Bvc2VfcmVt'
    'YXRjaBgDIAEoCzIWLmNoaWJyZS5Qcm9wb3NlUmVtYXRjaEgAUg5wcm9wb3NlUmVtYXRjaBI+Cg'
    '5hbnN3ZXJfcmVtYXRjaBgEIAEoCzIVLmNoaWJyZS5BbnN3ZXJSZW1hdGNoSABSDWFuc3dlclJl'
    'bWF0Y2gSLgoIcHJlc2VuY2UYBSABKAsyEC5jaGlicmUuUHJlc2VuY2VIAFIIcHJlc2VuY2USJQ'
    'oFbGVhdmUYBiABKAsyDS5jaGlicmUuTGVhdmVIAFIFbGVhdmUSOwoNZGlzbWlzc19yZWNhcBgH'
    'IAEoCzIULmNoaWJyZS5EaXNtaXNzUmVjYXBIAFIMZGlzbWlzc1JlY2FwEjgKDG1lbGRzX2Nob3'
    'NlbhgIIAEoCzITLmNoaWJyZS5NZWxkc0Nob3NlbkgAUgttZWxkc0Nob3NlbkIGCgRib2R5');

@$core.Deprecated('Use welcomeDescriptor instead')
const Welcome$json = {
  '1': 'Welcome',
  '2': [
    {'1': 'seat', '3': 1, '4': 1, '5': 13, '10': 'seat'},
    {'1': 'game_id', '3': 2, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `Welcome`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List welcomeDescriptor = $convert.base64Decode(
    'CgdXZWxjb21lEhIKBHNlYXQYASABKA1SBHNlYXQSFwoHZ2FtZV9pZBgCIAEoCVIGZ2FtZUlk');

@$core.Deprecated('Use rejectedDescriptor instead')
const Rejected$json = {
  '1': 'Rejected',
  '2': [
    {
      '1': 'reason',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.chibre.Rejected.Reason',
      '10': 'reason'
    },
  ],
  '4': [Rejected_Reason$json],
};

@$core.Deprecated('Use rejectedDescriptor instead')
const Rejected_Reason$json = {
  '1': 'Reason',
  '2': [
    {'1': 'REASON_UNSPECIFIED', '2': 0},
    {'1': 'REASON_VERSION_MISMATCH', '2': 1},
    {'1': 'REASON_GAME_FULL', '2': 2},
  ],
};

/// Descriptor for `Rejected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectedDescriptor = $convert.base64Decode(
    'CghSZWplY3RlZBIvCgZyZWFzb24YASABKA4yFy5jaGlicmUuUmVqZWN0ZWQuUmVhc29uUgZyZW'
    'Fzb24iUwoGUmVhc29uEhYKElJFQVNPTl9VTlNQRUNJRklFRBAAEhsKF1JFQVNPTl9WRVJTSU9O'
    'X01JU01BVENIEAESFAoQUkVBU09OX0dBTUVfRlVMTBAC');

@$core.Deprecated('Use trickDescriptor instead')
const Trick$json = {
  '1': 'Trick',
  '2': [
    {'1': 'leader', '3': 1, '4': 1, '5': 13, '10': 'leader'},
    {'1': 'cards', '3': 2, '4': 3, '5': 13, '10': 'cards'},
  ],
};

/// Descriptor for `Trick`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trickDescriptor = $convert.base64Decode(
    'CgVUcmljaxIWCgZsZWFkZXIYASABKA1SBmxlYWRlchIUCgVjYXJkcxgCIAMoDVIFY2FyZHM=');

@$core.Deprecated('Use seatMeldsDescriptor instead')
const SeatMelds$json = {
  '1': 'SeatMelds',
  '2': [
    {'1': 'announced_values', '3': 1, '4': 3, '5': 13, '10': 'announcedValues'},
    {'1': 'revealed', '3': 2, '4': 3, '5': 4, '10': 'revealed'},
  ],
};

/// Descriptor for `SeatMelds`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seatMeldsDescriptor = $convert.base64Decode(
    'CglTZWF0TWVsZHMSKQoQYW5ub3VuY2VkX3ZhbHVlcxgBIAMoDVIPYW5ub3VuY2VkVmFsdWVzEh'
    'oKCHJldmVhbGVkGAIgAygEUghyZXZlYWxlZA==');

@$core.Deprecated('Use rematchProposalDescriptor instead')
const RematchProposal$json = {
  '1': 'RematchProposal',
  '2': [
    {'1': 'proposed_by', '3': 1, '4': 1, '5': 13, '10': 'proposedBy'},
    {'1': 'same_cards', '3': 2, '4': 1, '5': 8, '10': 'sameCards'},
  ],
};

/// Descriptor for `RematchProposal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rematchProposalDescriptor = $convert.base64Decode(
    'Cg9SZW1hdGNoUHJvcG9zYWwSHwoLcHJvcG9zZWRfYnkYASABKA1SCnByb3Bvc2VkQnkSHQoKc2'
    'FtZV9jYXJkcxgCIAEoCFIJc2FtZUNhcmRz');

@$core.Deprecated('Use blunderDescriptor instead')
const Blunder$json = {
  '1': 'Blunder',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.chibre.Blunder.Kind',
      '10': 'kind'
    },
    {'1': 'seat', '3': 2, '4': 1, '5': 13, '10': 'seat'},
    {'1': 'round_index', '3': 3, '4': 1, '5': 13, '10': 'roundIndex'},
    {'1': 'trick_index', '3': 4, '4': 1, '5': 5, '10': 'trickIndex'},
    {'1': 'hand', '3': 5, '4': 1, '5': 4, '10': 'hand'},
    {'1': 'trick', '3': 6, '4': 3, '5': 13, '10': 'trick'},
    {
      '1': 'mode',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.chibre.TrumpMode',
      '10': 'mode'
    },
    {'1': 'points_lost', '3': 8, '4': 1, '5': 1, '10': 'pointsLost'},
    {'1': 'played_card', '3': 9, '4': 1, '5': 5, '10': 'playedCard'},
    {'1': 'best_card', '3': 10, '4': 1, '5': 5, '10': 'bestCard'},
    {
      '1': 'chosen_trump',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.chibre.TrumpMode',
      '10': 'chosenTrump'
    },
    {
      '1': 'best_trump',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.chibre.TrumpMode',
      '10': 'bestTrump'
    },
    {'1': 'missed_melds', '3': 13, '4': 3, '5': 4, '10': 'missedMelds'},
  ],
  '4': [Blunder_Kind$json],
};

@$core.Deprecated('Use blunderDescriptor instead')
const Blunder_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'KIND_TRUMP_CHOICE', '2': 0},
    {'1': 'KIND_CARD_PLAY', '2': 1},
    {'1': 'KIND_MISSED_MELD', '2': 2},
    {'1': 'KIND_MISSED_STOECK', '2': 3},
  ],
};

/// Descriptor for `Blunder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blunderDescriptor = $convert.base64Decode(
    'CgdCbHVuZGVyEigKBGtpbmQYASABKA4yFC5jaGlicmUuQmx1bmRlci5LaW5kUgRraW5kEhIKBH'
    'NlYXQYAiABKA1SBHNlYXQSHwoLcm91bmRfaW5kZXgYAyABKA1SCnJvdW5kSW5kZXgSHwoLdHJp'
    'Y2tfaW5kZXgYBCABKAVSCnRyaWNrSW5kZXgSEgoEaGFuZBgFIAEoBFIEaGFuZBIUCgV0cmljax'
    'gGIAMoDVIFdHJpY2sSJQoEbW9kZRgHIAEoDjIRLmNoaWJyZS5UcnVtcE1vZGVSBG1vZGUSHwoL'
    'cG9pbnRzX2xvc3QYCCABKAFSCnBvaW50c0xvc3QSHwoLcGxheWVkX2NhcmQYCSABKAVSCnBsYX'
    'llZENhcmQSGwoJYmVzdF9jYXJkGAogASgFUghiZXN0Q2FyZBI0CgxjaG9zZW5fdHJ1bXAYCyAB'
    'KA4yES5jaGlicmUuVHJ1bXBNb2RlUgtjaG9zZW5UcnVtcBIwCgpiZXN0X3RydW1wGAwgASgOMh'
    'EuY2hpYnJlLlRydW1wTW9kZVIJYmVzdFRydW1wEiEKDG1pc3NlZF9tZWxkcxgNIAMoBFILbWlz'
    'c2VkTWVsZHMiXwoES2luZBIVChFLSU5EX1RSVU1QX0NIT0lDRRAAEhIKDktJTkRfQ0FSRF9QTE'
    'FZEAESFAoQS0lORF9NSVNTRURfTUVMRBACEhYKEktJTkRfTUlTU0VEX1NUT0VDSxAD');

@$core.Deprecated('Use insightsDescriptor instead')
const Insights$json = {
  '1': 'Insights',
  '2': [
    {
      '1': 'blunders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.chibre.Blunder',
      '10': 'blunders'
    },
  ],
};

/// Descriptor for `Insights`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List insightsDescriptor = $convert.base64Decode(
    'CghJbnNpZ2h0cxIrCghibHVuZGVycxgBIAMoCzIPLmNoaWJyZS5CbHVuZGVyUghibHVuZGVycw'
    '==');

@$core.Deprecated('Use tableSnapshotDescriptor instead')
const TableSnapshot$json = {
  '1': 'TableSnapshot',
  '2': [
    {'1': 'viewer', '3': 1, '4': 1, '5': 13, '10': 'viewer'},
    {'1': 'nicknames', '3': 2, '4': 3, '5': 9, '10': 'nicknames'},
    {
      '1': 'options',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.chibre.GameOptions',
      '10': 'options'
    },
    {
      '1': 'phase',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.chibre.TableSnapshot.Phase',
      '10': 'phase'
    },
    {'1': 'round_index', '3': 6, '4': 1, '5': 13, '10': 'roundIndex'},
    {'1': 'hand', '3': 7, '4': 1, '5': 4, '10': 'hand'},
    {
      '1': 'mode',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.chibre.TrumpMode',
      '10': 'mode'
    },
    {'1': 'trump_chooser', '3': 9, '4': 1, '5': 13, '10': 'trumpChooser'},
    {'1': 'chibred', '3': 10, '4': 1, '5': 8, '10': 'chibred'},
    {'1': 'seat_to_act', '3': 11, '4': 1, '5': 5, '10': 'seatToAct'},
    {
      '1': 'completed_tricks',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.chibre.Trick',
      '10': 'completedTricks'
    },
    {
      '1': 'current_trick',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.chibre.Trick',
      '10': 'currentTrick'
    },
    {
      '1': 'melds',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.chibre.SeatMelds',
      '10': 'melds'
    },
    {'1': 'stoeck_seat', '3': 15, '4': 1, '5': 5, '10': 'stoeckSeat'},
    {'1': 'scores', '3': 16, '4': 3, '5': 5, '10': 'scores'},
    {'1': 'round_points', '3': 17, '4': 3, '5': 5, '10': 'roundPoints'},
    {'1': 'winning_team', '3': 18, '4': 1, '5': 5, '10': 'winningTeam'},
    {'1': 'paused_for', '3': 19, '4': 1, '5': 9, '10': 'pausedFor'},
    {
      '1': 'rematch',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.chibre.RematchProposal',
      '10': 'rematch'
    },
    {
      '1': 'insights',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.chibre.Insights',
      '10': 'insights'
    },
    {'1': 'trick_hold_ms', '3': 22, '4': 1, '5': 13, '10': 'trickHoldMs'},
    {'1': 'recap_for', '3': 23, '4': 3, '5': 13, '10': 'recapFor'},
    {'1': 'meld_choice_for', '3': 24, '4': 3, '5': 13, '10': 'meldChoiceFor'},
    {'1': 'assistance', '3': 25, '4': 1, '5': 8, '10': 'assistance'},
    {'1': 'sort_by_trump', '3': 26, '4': 1, '5': 8, '10': 'sortByTrump'},
    {'1': 'auto_announce', '3': 27, '4': 1, '5': 8, '10': 'autoAnnounce'},
    {'1': 'thinking_time_ms', '3': 28, '4': 1, '5': 13, '10': 'thinkingTimeMs'},
  ],
  '4': [TableSnapshot_Phase$json],
  '9': [
    {'1': 4, '2': 5},
  ],
};

@$core.Deprecated('Use tableSnapshotDescriptor instead')
const TableSnapshot_Phase$json = {
  '1': 'Phase',
  '2': [
    {'1': 'PHASE_WAITING_FOR_PLAYER', '2': 0},
    {'1': 'PHASE_CHOOSING_TRUMP', '2': 1},
    {'1': 'PHASE_PLAYING', '2': 2},
    {'1': 'PHASE_ROUND_OVER', '2': 3},
    {'1': 'PHASE_GAME_OVER', '2': 4},
  ],
};

/// Descriptor for `TableSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tableSnapshotDescriptor = $convert.base64Decode(
    'Cg1UYWJsZVNuYXBzaG90EhYKBnZpZXdlchgBIAEoDVIGdmlld2VyEhwKCW5pY2tuYW1lcxgCIA'
    'MoCVIJbmlja25hbWVzEi0KB29wdGlvbnMYAyABKAsyEy5jaGlicmUuR2FtZU9wdGlvbnNSB29w'
    'dGlvbnMSMQoFcGhhc2UYBSABKA4yGy5jaGlicmUuVGFibGVTbmFwc2hvdC5QaGFzZVIFcGhhc2'
    'USHwoLcm91bmRfaW5kZXgYBiABKA1SCnJvdW5kSW5kZXgSEgoEaGFuZBgHIAEoBFIEaGFuZBIl'
    'CgRtb2RlGAggASgOMhEuY2hpYnJlLlRydW1wTW9kZVIEbW9kZRIjCg10cnVtcF9jaG9vc2VyGA'
    'kgASgNUgx0cnVtcENob29zZXISGAoHY2hpYnJlZBgKIAEoCFIHY2hpYnJlZBIeCgtzZWF0X3Rv'
    'X2FjdBgLIAEoBVIJc2VhdFRvQWN0EjgKEGNvbXBsZXRlZF90cmlja3MYDCADKAsyDS5jaGlicm'
    'UuVHJpY2tSD2NvbXBsZXRlZFRyaWNrcxIyCg1jdXJyZW50X3RyaWNrGA0gASgLMg0uY2hpYnJl'
    'LlRyaWNrUgxjdXJyZW50VHJpY2sSJwoFbWVsZHMYDiADKAsyES5jaGlicmUuU2VhdE1lbGRzUg'
    'VtZWxkcxIfCgtzdG9lY2tfc2VhdBgPIAEoBVIKc3RvZWNrU2VhdBIWCgZzY29yZXMYECADKAVS'
    'BnNjb3JlcxIhCgxyb3VuZF9wb2ludHMYESADKAVSC3JvdW5kUG9pbnRzEiEKDHdpbm5pbmdfdG'
    'VhbRgSIAEoBVILd2lubmluZ1RlYW0SHQoKcGF1c2VkX2ZvchgTIAEoCVIJcGF1c2VkRm9yEjEK'
    'B3JlbWF0Y2gYFCABKAsyFy5jaGlicmUuUmVtYXRjaFByb3Bvc2FsUgdyZW1hdGNoEiwKCGluc2'
    'lnaHRzGBUgASgLMhAuY2hpYnJlLkluc2lnaHRzUghpbnNpZ2h0cxIiCg10cmlja19ob2xkX21z'
    'GBYgASgNUgt0cmlja0hvbGRNcxIbCglyZWNhcF9mb3IYFyADKA1SCHJlY2FwRm9yEiYKD21lbG'
    'RfY2hvaWNlX2ZvchgYIAMoDVINbWVsZENob2ljZUZvchIeCgphc3Npc3RhbmNlGBkgASgIUgph'
    'c3Npc3RhbmNlEiIKDXNvcnRfYnlfdHJ1bXAYGiABKAhSC3NvcnRCeVRydW1wEiMKDWF1dG9fYW'
    '5ub3VuY2UYGyABKAhSDGF1dG9Bbm5vdW5jZRIoChB0aGlua2luZ190aW1lX21zGBwgASgNUg50'
    'aGlua2luZ1RpbWVNcyJ9CgVQaGFzZRIcChhQSEFTRV9XQUlUSU5HX0ZPUl9QTEFZRVIQABIYCh'
    'RQSEFTRV9DSE9PU0lOR19UUlVNUBABEhEKDVBIQVNFX1BMQVlJTkcQAhIUChBQSEFTRV9ST1VO'
    'RF9PVkVSEAMSEwoPUEhBU0VfR0FNRV9PVkVSEARKBAgEEAU=');

@$core.Deprecated('Use actionRejectedDescriptor instead')
const ActionRejected$json = {
  '1': 'ActionRejected',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ActionRejected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionRejectedDescriptor = $convert
    .base64Decode('Cg5BY3Rpb25SZWplY3RlZBIWCgZyZWFzb24YASABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use closedDescriptor instead')
const Closed$json = {
  '1': 'Closed',
};

/// Descriptor for `Closed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closedDescriptor =
    $convert.base64Decode('CgZDbG9zZWQ=');

@$core.Deprecated('Use hostMessageDescriptor instead')
const HostMessage$json = {
  '1': 'HostMessage',
  '2': [
    {
      '1': 'welcome',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.chibre.Welcome',
      '9': 0,
      '10': 'welcome'
    },
    {
      '1': 'rejected',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.chibre.Rejected',
      '9': 0,
      '10': 'rejected'
    },
    {
      '1': 'table',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.chibre.TableSnapshot',
      '9': 0,
      '10': 'table'
    },
    {
      '1': 'action_rejected',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.chibre.ActionRejected',
      '9': 0,
      '10': 'actionRejected'
    },
    {
      '1': 'closed',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.chibre.Closed',
      '9': 0,
      '10': 'closed'
    },
  ],
  '8': [
    {'1': 'body'},
  ],
};

/// Descriptor for `HostMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hostMessageDescriptor = $convert.base64Decode(
    'CgtIb3N0TWVzc2FnZRIrCgd3ZWxjb21lGAEgASgLMg8uY2hpYnJlLldlbGNvbWVIAFIHd2VsY2'
    '9tZRIuCghyZWplY3RlZBgCIAEoCzIQLmNoaWJyZS5SZWplY3RlZEgAUghyZWplY3RlZBItCgV0'
    'YWJsZRgDIAEoCzIVLmNoaWJyZS5UYWJsZVNuYXBzaG90SABSBXRhYmxlEkEKD2FjdGlvbl9yZW'
    'plY3RlZBgEIAEoCzIWLmNoaWJyZS5BY3Rpb25SZWplY3RlZEgAUg5hY3Rpb25SZWplY3RlZBIo'
    'CgZjbG9zZWQYBSABKAsyDi5jaGlicmUuQ2xvc2VkSABSBmNsb3NlZEIGCgRib2R5');

@$core.Deprecated('Use roundDescriptor instead')
const Round$json = {
  '1': 'Round',
  '2': [
    {'1': 'deal', '3': 1, '4': 3, '5': 4, '10': 'deal'},
    {'1': 'trump_chooser', '3': 2, '4': 1, '5': 13, '10': 'trumpChooser'},
    {
      '1': 'actions',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.chibre.Action',
      '10': 'actions'
    },
  ],
};

/// Descriptor for `Round`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roundDescriptor = $convert.base64Decode(
    'CgVSb3VuZBISCgRkZWFsGAEgAygEUgRkZWFsEiMKDXRydW1wX2Nob29zZXIYAiABKA1SDHRydW'
    '1wQ2hvb3NlchIoCgdhY3Rpb25zGAMgAygLMg4uY2hpYnJlLkFjdGlvblIHYWN0aW9ucw==');

@$core.Deprecated('Use gameRecordDescriptor instead')
const GameRecord$json = {
  '1': 'GameRecord',
  '2': [
    {
      '1': 'options',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.chibre.GameOptions',
      '10': 'options'
    },
    {
      '1': 'rounds',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.chibre.Round',
      '10': 'rounds'
    },
  ],
};

/// Descriptor for `GameRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameRecordDescriptor = $convert.base64Decode(
    'CgpHYW1lUmVjb3JkEi0KB29wdGlvbnMYASABKAsyEy5jaGlicmUuR2FtZU9wdGlvbnNSB29wdG'
    'lvbnMSJQoGcm91bmRzGAIgAygLMg0uY2hpYnJlLlJvdW5kUgZyb3VuZHM=');

@$core.Deprecated('Use savedGameDescriptor instead')
const SavedGame$json = {
  '1': 'SavedGame',
  '2': [
    {'1': 'game_id', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'game_name', '3': 2, '4': 1, '5': 9, '10': 'gameName'},
    {'1': 'nicknames', '3': 3, '4': 3, '5': 9, '10': 'nicknames'},
    {
      '1': 'joiner_installation_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'joinerInstallationId'
    },
    {
      '1': 'record',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.chibre.GameRecord',
      '10': 'record'
    },
    {'1': 'trick_hold_ms', '3': 7, '4': 1, '5': 13, '10': 'trickHoldMs'},
    {'1': 'assistance', '3': 8, '4': 1, '5': 8, '10': 'assistance'},
    {'1': 'sort_by_trump', '3': 9, '4': 1, '5': 8, '10': 'sortByTrump'},
    {'1': 'auto_announce', '3': 10, '4': 1, '5': 8, '10': 'autoAnnounce'},
    {'1': 'thinking_time_ms', '3': 11, '4': 1, '5': 13, '10': 'thinkingTimeMs'},
  ],
  '9': [
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `SavedGame`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savedGameDescriptor = $convert.base64Decode(
    'CglTYXZlZEdhbWUSFwoHZ2FtZV9pZBgBIAEoCVIGZ2FtZUlkEhsKCWdhbWVfbmFtZRgCIAEoCV'
    'IIZ2FtZU5hbWUSHAoJbmlja25hbWVzGAMgAygJUgluaWNrbmFtZXMSNAoWam9pbmVyX2luc3Rh'
    'bGxhdGlvbl9pZBgEIAEoCVIUam9pbmVySW5zdGFsbGF0aW9uSWQSKgoGcmVjb3JkGAYgASgLMh'
    'IuY2hpYnJlLkdhbWVSZWNvcmRSBnJlY29yZBIiCg10cmlja19ob2xkX21zGAcgASgNUgt0cmlj'
    'a0hvbGRNcxIeCgphc3Npc3RhbmNlGAggASgIUgphc3Npc3RhbmNlEiIKDXNvcnRfYnlfdHJ1bX'
    'AYCSABKAhSC3NvcnRCeVRydW1wEiMKDWF1dG9fYW5ub3VuY2UYCiABKAhSDGF1dG9Bbm5vdW5j'
    'ZRIoChB0aGlua2luZ190aW1lX21zGAsgASgNUg50aGlua2luZ1RpbWVNc0oECAUQBg==');
