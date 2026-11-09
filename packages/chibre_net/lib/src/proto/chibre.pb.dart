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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chibre.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'chibre.pbenum.dart';

class GameOptions extends $pb.GeneratedMessage {
  factory GameOptions({
    $core.int? targetScore,
    $core.bool? obenUndeAllowed,
    $core.bool? multipliersEnabled,
    $core.bool? finishLastRound,
  }) {
    final result = GameOptions._();
    if (targetScore != null) result.targetScore = targetScore;
    if (obenUndeAllowed != null) result.obenUndeAllowed = obenUndeAllowed;
    if (multipliersEnabled != null)
      result.multipliersEnabled = multipliersEnabled;
    if (finishLastRound != null) result.finishLastRound = finishLastRound;
    return result;
  }

  GameOptions._();

  factory GameOptions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GameOptions()..mergeFromBuffer(data, registry);
  factory GameOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GameOptions()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GameOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: GameOptions.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'targetScore',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'obenUndeAllowed')
    ..aOB(3, _omitFieldNames ? '' : 'multipliersEnabled')
    ..aOB(4, _omitFieldNames ? '' : 'finishLastRound')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameOptions copyWith(void Function(GameOptions) updates) =>
      super.copyWith((message) => updates(message as GameOptions))
          as GameOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GameOptions() / GameOptions.new instead')
  static GameOptions create() => GameOptions._();
  static $pb.GeneratedMessage $_createMessage() => GameOptions._();
  @$core.override
  GameOptions createEmptyInstance() => GameOptions._();
  @$core.pragma('dart2js:noInline')
  static GameOptions getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameOptions>(
          GameOptions.$_createMessage);
  static GameOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get targetScore => $_getIZ(0);
  @$pb.TagNumber(1)
  set targetScore($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTargetScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get obenUndeAllowed => $_getBF(1);
  @$pb.TagNumber(2)
  set obenUndeAllowed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasObenUndeAllowed() => $_has(1);
  @$pb.TagNumber(2)
  void clearObenUndeAllowed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get multipliersEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set multipliersEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMultipliersEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearMultipliersEnabled() => $_clearField(3);

  /// The round in which a team reaches the target is played to the end; the
  /// first team to reach it still wins.
  @$pb.TagNumber(4)
  $core.bool get finishLastRound => $_getBF(3);
  @$pb.TagNumber(4)
  set finishLastRound($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFinishLastRound() => $_has(3);
  @$pb.TagNumber(4)
  void clearFinishLastRound() => $_clearField(4);
}

/// Broadcast by the host so other phones can list the game.
class GameAdvert extends $pb.GeneratedMessage {
  factory GameAdvert({
    $core.int? protocolVersion,
    $core.String? gameId,
    $core.String? name,
    $core.String? hostNickname,
    $core.int? port,
    $core.String? reservedFor,
    $core.Iterable<$core.int>? scores,
  }) {
    final result = GameAdvert._();
    if (protocolVersion != null) result.protocolVersion = protocolVersion;
    if (gameId != null) result.gameId = gameId;
    if (name != null) result.name = name;
    if (hostNickname != null) result.hostNickname = hostNickname;
    if (port != null) result.port = port;
    if (reservedFor != null) result.reservedFor = reservedFor;
    if (scores != null) result.scores.addAll(scores);
    return result;
  }

  GameAdvert._();

  factory GameAdvert.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GameAdvert()..mergeFromBuffer(data, registry);
  factory GameAdvert.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GameAdvert()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GameAdvert',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: GameAdvert.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'protocolVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'gameId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'hostNickname')
    ..aI(5, _omitFieldNames ? '' : 'port', fieldType: $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'reservedFor')
    ..p<$core.int>(7, _omitFieldNames ? '' : 'scores', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameAdvert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameAdvert copyWith(void Function(GameAdvert) updates) =>
      super.copyWith((message) => updates(message as GameAdvert)) as GameAdvert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GameAdvert() / GameAdvert.new instead')
  static GameAdvert create() => GameAdvert._();
  static $pb.GeneratedMessage $_createMessage() => GameAdvert._();
  @$core.override
  GameAdvert createEmptyInstance() => GameAdvert._();
  @$core.pragma('dart2js:noInline')
  static GameAdvert getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GameAdvert>(GameAdvert.$_createMessage);
  static GameAdvert? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get protocolVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set protocolVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProtocolVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearProtocolVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gameId => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGameId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get hostNickname => $_getSZ(3);
  @$pb.TagNumber(4)
  set hostNickname($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHostNickname() => $_has(3);
  @$pb.TagNumber(4)
  void clearHostNickname() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get port => $_getIZ(4);
  @$pb.TagNumber(5)
  set port($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPort() => $_has(4);
  @$pb.TagNumber(5)
  void clearPort() => $_clearField(5);

  /// Set when the game is paused: only this installation may (re)join.
  @$pb.TagNumber(6)
  $core.String get reservedFor => $_getSZ(5);
  @$pb.TagNumber(6)
  set reservedFor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReservedFor() => $_has(5);
  @$pb.TagNumber(6)
  void clearReservedFor() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.int> get scores => $_getList(6);
}

class ChooseTrump extends $pb.GeneratedMessage {
  factory ChooseTrump({
    TrumpMode? mode,
  }) {
    final result = ChooseTrump._();
    if (mode != null) result.mode = mode;
    return result;
  }

  ChooseTrump._();

  factory ChooseTrump.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChooseTrump()..mergeFromBuffer(data, registry);
  factory ChooseTrump.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChooseTrump()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChooseTrump',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: ChooseTrump.$_createMessage)
    ..aE<TrumpMode>(1, _omitFieldNames ? '' : 'mode',
        enumValues: TrumpMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChooseTrump clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChooseTrump copyWith(void Function(ChooseTrump) updates) =>
      super.copyWith((message) => updates(message as ChooseTrump))
          as ChooseTrump;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChooseTrump() / ChooseTrump.new instead')
  static ChooseTrump create() => ChooseTrump._();
  static $pb.GeneratedMessage $_createMessage() => ChooseTrump._();
  @$core.override
  ChooseTrump createEmptyInstance() => ChooseTrump._();
  @$core.pragma('dart2js:noInline')
  static ChooseTrump getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChooseTrump>(
          ChooseTrump.$_createMessage);
  static ChooseTrump? _defaultInstance;

  @$pb.TagNumber(1)
  TrumpMode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode(TrumpMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);
}

class Chibrer extends $pb.GeneratedMessage {
  factory Chibrer() => Chibrer._();

  Chibrer._();

  factory Chibrer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Chibrer()..mergeFromBuffer(data, registry);
  factory Chibrer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Chibrer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chibrer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Chibrer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chibrer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chibrer copyWith(void Function(Chibrer) updates) =>
      super.copyWith((message) => updates(message as Chibrer)) as Chibrer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Chibrer() / Chibrer.new instead')
  static Chibrer create() => Chibrer._();
  static $pb.GeneratedMessage $_createMessage() => Chibrer._();
  @$core.override
  Chibrer createEmptyInstance() => Chibrer._();
  @$core.pragma('dart2js:noInline')
  static Chibrer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Chibrer>(Chibrer.$_createMessage);
  static Chibrer? _defaultInstance;
}

class PlayCard extends $pb.GeneratedMessage {
  factory PlayCard({
    $core.int? card,
    $core.Iterable<$fixnum.Int64>? melds,
    $core.bool? stoeck,
  }) {
    final result = PlayCard._();
    if (card != null) result.card = card;
    if (melds != null) result.melds.addAll(melds);
    if (stoeck != null) result.stoeck = stoeck;
    return result;
  }

  PlayCard._();

  factory PlayCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayCard()..mergeFromBuffer(data, registry);
  factory PlayCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayCard',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: PlayCard.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'card', fieldType: $pb.PbFieldType.OU3)
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'melds', $pb.PbFieldType.KU6)
    ..aOB(3, _omitFieldNames ? '' : 'stoeck')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayCard copyWith(void Function(PlayCard) updates) =>
      super.copyWith((message) => updates(message as PlayCard)) as PlayCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayCard() / PlayCard.new instead')
  static PlayCard create() => PlayCard._();
  static $pb.GeneratedMessage $_createMessage() => PlayCard._();
  @$core.override
  PlayCard createEmptyInstance() => PlayCard._();
  @$core.pragma('dart2js:noInline')
  static PlayCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayCard>(PlayCard.$_createMessage);
  static PlayCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get card => $_getIZ(0);
  @$pb.TagNumber(1)
  set card($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCard() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get melds => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get stoeck => $_getBF(2);
  @$pb.TagNumber(3)
  set stoeck($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStoeck() => $_has(2);
  @$pb.TagNumber(3)
  void clearStoeck() => $_clearField(3);
}

enum Action_Kind { chooseTrump, chibrer, playCard, notSet }

class Action extends $pb.GeneratedMessage {
  factory Action({
    $core.int? seat,
    ChooseTrump? chooseTrump,
    Chibrer? chibrer,
    PlayCard? playCard,
  }) {
    final result = Action._();
    if (seat != null) result.seat = seat;
    if (chooseTrump != null) result.chooseTrump = chooseTrump;
    if (chibrer != null) result.chibrer = chibrer;
    if (playCard != null) result.playCard = playCard;
    return result;
  }

  Action._();

  factory Action.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Action()..mergeFromBuffer(data, registry);
  factory Action.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Action()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Action_Kind> _Action_KindByTag = {
    2: Action_Kind.chooseTrump,
    3: Action_Kind.chibrer,
    4: Action_Kind.playCard,
    0: Action_Kind.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Action',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Action.$_createMessage)
    ..oo(0, [2, 3, 4])
    ..aI(1, _omitFieldNames ? '' : 'seat', fieldType: $pb.PbFieldType.OU3)
    ..aOM<ChooseTrump>(2, _omitFieldNames ? '' : 'chooseTrump',
        subBuilder: ChooseTrump.$_createMessage)
    ..aOM<Chibrer>(3, _omitFieldNames ? '' : 'chibrer',
        subBuilder: Chibrer.$_createMessage)
    ..aOM<PlayCard>(4, _omitFieldNames ? '' : 'playCard',
        subBuilder: PlayCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Action clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Action copyWith(void Function(Action) updates) =>
      super.copyWith((message) => updates(message as Action)) as Action;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Action() / Action.new instead')
  static Action create() => Action._();
  static $pb.GeneratedMessage $_createMessage() => Action._();
  @$core.override
  Action createEmptyInstance() => Action._();
  @$core.pragma('dart2js:noInline')
  static Action getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Action>(Action.$_createMessage);
  static Action? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  Action_Kind whichKind() => _Action_KindByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearKind() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get seat => $_getIZ(0);
  @$pb.TagNumber(1)
  set seat($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeat() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeat() => $_clearField(1);

  @$pb.TagNumber(2)
  ChooseTrump get chooseTrump => $_getN(1);
  @$pb.TagNumber(2)
  set chooseTrump(ChooseTrump value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChooseTrump() => $_has(1);
  @$pb.TagNumber(2)
  void clearChooseTrump() => $_clearField(2);
  @$pb.TagNumber(2)
  ChooseTrump ensureChooseTrump() => $_ensure(1);

  @$pb.TagNumber(3)
  Chibrer get chibrer => $_getN(2);
  @$pb.TagNumber(3)
  set chibrer(Chibrer value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasChibrer() => $_has(2);
  @$pb.TagNumber(3)
  void clearChibrer() => $_clearField(3);
  @$pb.TagNumber(3)
  Chibrer ensureChibrer() => $_ensure(2);

  @$pb.TagNumber(4)
  PlayCard get playCard => $_getN(3);
  @$pb.TagNumber(4)
  set playCard(PlayCard value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayCard() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayCard() => $_clearField(4);
  @$pb.TagNumber(4)
  PlayCard ensurePlayCard() => $_ensure(3);
}

class Hello extends $pb.GeneratedMessage {
  factory Hello({
    $core.int? protocolVersion,
    $core.String? installationId,
    $core.String? nickname,
  }) {
    final result = Hello._();
    if (protocolVersion != null) result.protocolVersion = protocolVersion;
    if (installationId != null) result.installationId = installationId;
    if (nickname != null) result.nickname = nickname;
    return result;
  }

  Hello._();

  factory Hello.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Hello()..mergeFromBuffer(data, registry);
  factory Hello.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Hello()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Hello',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Hello.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'protocolVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'installationId')
    ..aOS(3, _omitFieldNames ? '' : 'nickname')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hello clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hello copyWith(void Function(Hello) updates) =>
      super.copyWith((message) => updates(message as Hello)) as Hello;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Hello() / Hello.new instead')
  static Hello create() => Hello._();
  static $pb.GeneratedMessage $_createMessage() => Hello._();
  @$core.override
  Hello createEmptyInstance() => Hello._();
  @$core.pragma('dart2js:noInline')
  static Hello getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Hello>(Hello.$_createMessage);
  static Hello? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get protocolVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set protocolVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProtocolVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearProtocolVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get installationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set installationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstallationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstallationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nickname => $_getSZ(2);
  @$pb.TagNumber(3)
  set nickname($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNickname() => $_has(2);
  @$pb.TagNumber(3)
  void clearNickname() => $_clearField(3);
}

class ProposeRematch extends $pb.GeneratedMessage {
  factory ProposeRematch({
    $core.bool? sameCards,
  }) {
    final result = ProposeRematch._();
    if (sameCards != null) result.sameCards = sameCards;
    return result;
  }

  ProposeRematch._();

  factory ProposeRematch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProposeRematch()..mergeFromBuffer(data, registry);
  factory ProposeRematch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProposeRematch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProposeRematch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: ProposeRematch.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'sameCards')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposeRematch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposeRematch copyWith(void Function(ProposeRematch) updates) =>
      super.copyWith((message) => updates(message as ProposeRematch))
          as ProposeRematch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProposeRematch() / ProposeRematch.new instead')
  static ProposeRematch create() => ProposeRematch._();
  static $pb.GeneratedMessage $_createMessage() => ProposeRematch._();
  @$core.override
  ProposeRematch createEmptyInstance() => ProposeRematch._();
  @$core.pragma('dart2js:noInline')
  static ProposeRematch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProposeRematch>(
          ProposeRematch.$_createMessage);
  static ProposeRematch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get sameCards => $_getBF(0);
  @$pb.TagNumber(1)
  set sameCards($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSameCards() => $_has(0);
  @$pb.TagNumber(1)
  void clearSameCards() => $_clearField(1);
}

class AnswerRematch extends $pb.GeneratedMessage {
  factory AnswerRematch({
    $core.bool? accept,
  }) {
    final result = AnswerRematch._();
    if (accept != null) result.accept = accept;
    return result;
  }

  AnswerRematch._();

  factory AnswerRematch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnswerRematch()..mergeFromBuffer(data, registry);
  factory AnswerRematch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnswerRematch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnswerRematch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: AnswerRematch.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'accept')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerRematch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerRematch copyWith(void Function(AnswerRematch) updates) =>
      super.copyWith((message) => updates(message as AnswerRematch))
          as AnswerRematch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AnswerRematch() / AnswerRematch.new instead')
  static AnswerRematch create() => AnswerRematch._();
  static $pb.GeneratedMessage $_createMessage() => AnswerRematch._();
  @$core.override
  AnswerRematch createEmptyInstance() => AnswerRematch._();
  @$core.pragma('dart2js:noInline')
  static AnswerRematch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnswerRematch>(
          AnswerRematch.$_createMessage);
  static AnswerRematch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get accept => $_getBF(0);
  @$pb.TagNumber(1)
  set accept($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccept() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccept() => $_clearField(1);
}

/// The player put the app in the background (away) or came back.
class Presence extends $pb.GeneratedMessage {
  factory Presence({
    $core.bool? away,
  }) {
    final result = Presence._();
    if (away != null) result.away = away;
    return result;
  }

  Presence._();

  factory Presence.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Presence()..mergeFromBuffer(data, registry);
  factory Presence.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Presence()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Presence',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Presence.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'away')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence copyWith(void Function(Presence) updates) =>
      super.copyWith((message) => updates(message as Presence)) as Presence;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Presence() / Presence.new instead')
  static Presence create() => Presence._();
  static $pb.GeneratedMessage $_createMessage() => Presence._();
  @$core.override
  Presence createEmptyInstance() => Presence._();
  @$core.pragma('dart2js:noInline')
  static Presence getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Presence>(Presence.$_createMessage);
  static Presence? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get away => $_getBF(0);
  @$pb.TagNumber(1)
  set away($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAway() => $_has(0);
  @$pb.TagNumber(1)
  void clearAway() => $_clearField(1);
}

class Leave extends $pb.GeneratedMessage {
  factory Leave() => Leave._();

  Leave._();

  factory Leave.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Leave()..mergeFromBuffer(data, registry);
  factory Leave.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Leave()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Leave',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Leave.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Leave clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Leave copyWith(void Function(Leave) updates) =>
      super.copyWith((message) => updates(message as Leave)) as Leave;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Leave() / Leave.new instead')
  static Leave create() => Leave._();
  static $pb.GeneratedMessage $_createMessage() => Leave._();
  @$core.override
  Leave createEmptyInstance() => Leave._();
  @$core.pragma('dart2js:noInline')
  static Leave getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Leave>(Leave.$_createMessage);
  static Leave? _defaultInstance;
}

/// The player closed the recap of the announcements (melds, Stöck).
class DismissRecap extends $pb.GeneratedMessage {
  factory DismissRecap() => DismissRecap._();

  DismissRecap._();

  factory DismissRecap.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissRecap()..mergeFromBuffer(data, registry);
  factory DismissRecap.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissRecap()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissRecap',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: DismissRecap.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRecap clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRecap copyWith(void Function(DismissRecap) updates) =>
      super.copyWith((message) => updates(message as DismissRecap))
          as DismissRecap;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DismissRecap() / DismissRecap.new instead')
  static DismissRecap create() => DismissRecap._();
  static $pb.GeneratedMessage $_createMessage() => DismissRecap._();
  @$core.override
  DismissRecap createEmptyInstance() => DismissRecap._();
  @$core.pragma('dart2js:noInline')
  static DismissRecap getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DismissRecap>(
          DismissRecap.$_createMessage);
  static DismissRecap? _defaultInstance;
}

/// The player closed the summary of the round.
class DismissRoundSummary extends $pb.GeneratedMessage {
  factory DismissRoundSummary() => DismissRoundSummary._();

  DismissRoundSummary._();

  factory DismissRoundSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissRoundSummary()..mergeFromBuffer(data, registry);
  factory DismissRoundSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissRoundSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissRoundSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: DismissRoundSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRoundSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRoundSummary copyWith(void Function(DismissRoundSummary) updates) =>
      super.copyWith((message) => updates(message as DismissRoundSummary))
          as DismissRoundSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use DismissRoundSummary() / DismissRoundSummary.new instead')
  static DismissRoundSummary create() => DismissRoundSummary._();
  static $pb.GeneratedMessage $_createMessage() => DismissRoundSummary._();
  @$core.override
  DismissRoundSummary createEmptyInstance() => DismissRoundSummary._();
  @$core.pragma('dart2js:noInline')
  static DismissRoundSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DismissRoundSummary>(
          DismissRoundSummary.$_createMessage);
  static DismissRoundSummary? _defaultInstance;
}

/// The player chose their melds (sent with their first card) or not to
/// announce any.
class MeldsChosen extends $pb.GeneratedMessage {
  factory MeldsChosen() => MeldsChosen._();

  MeldsChosen._();

  factory MeldsChosen.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MeldsChosen()..mergeFromBuffer(data, registry);
  factory MeldsChosen.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MeldsChosen()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MeldsChosen',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: MeldsChosen.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MeldsChosen clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MeldsChosen copyWith(void Function(MeldsChosen) updates) =>
      super.copyWith((message) => updates(message as MeldsChosen))
          as MeldsChosen;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MeldsChosen() / MeldsChosen.new instead')
  static MeldsChosen create() => MeldsChosen._();
  static $pb.GeneratedMessage $_createMessage() => MeldsChosen._();
  @$core.override
  MeldsChosen createEmptyInstance() => MeldsChosen._();
  @$core.pragma('dart2js:noInline')
  static MeldsChosen getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MeldsChosen>(
          MeldsChosen.$_createMessage);
  static MeldsChosen? _defaultInstance;
}

enum ClientMessage_Body {
  hello,
  action,
  proposeRematch,
  answerRematch,
  presence,
  leave,
  dismissRecap,
  meldsChosen,
  dismissRoundSummary,
  notSet
}

class ClientMessage extends $pb.GeneratedMessage {
  factory ClientMessage({
    Hello? hello,
    Action? action,
    ProposeRematch? proposeRematch,
    AnswerRematch? answerRematch,
    Presence? presence,
    Leave? leave,
    DismissRecap? dismissRecap,
    MeldsChosen? meldsChosen,
    DismissRoundSummary? dismissRoundSummary,
  }) {
    final result = ClientMessage._();
    if (hello != null) result.hello = hello;
    if (action != null) result.action = action;
    if (proposeRematch != null) result.proposeRematch = proposeRematch;
    if (answerRematch != null) result.answerRematch = answerRematch;
    if (presence != null) result.presence = presence;
    if (leave != null) result.leave = leave;
    if (dismissRecap != null) result.dismissRecap = dismissRecap;
    if (meldsChosen != null) result.meldsChosen = meldsChosen;
    if (dismissRoundSummary != null)
      result.dismissRoundSummary = dismissRoundSummary;
    return result;
  }

  ClientMessage._();

  factory ClientMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClientMessage()..mergeFromBuffer(data, registry);
  factory ClientMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClientMessage()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ClientMessage_Body>
      _ClientMessage_BodyByTag = {
    1: ClientMessage_Body.hello,
    2: ClientMessage_Body.action,
    3: ClientMessage_Body.proposeRematch,
    4: ClientMessage_Body.answerRematch,
    5: ClientMessage_Body.presence,
    6: ClientMessage_Body.leave,
    7: ClientMessage_Body.dismissRecap,
    8: ClientMessage_Body.meldsChosen,
    9: ClientMessage_Body.dismissRoundSummary,
    0: ClientMessage_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: ClientMessage.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..aOM<Hello>(1, _omitFieldNames ? '' : 'hello',
        subBuilder: Hello.$_createMessage)
    ..aOM<Action>(2, _omitFieldNames ? '' : 'action',
        subBuilder: Action.$_createMessage)
    ..aOM<ProposeRematch>(3, _omitFieldNames ? '' : 'proposeRematch',
        subBuilder: ProposeRematch.$_createMessage)
    ..aOM<AnswerRematch>(4, _omitFieldNames ? '' : 'answerRematch',
        subBuilder: AnswerRematch.$_createMessage)
    ..aOM<Presence>(5, _omitFieldNames ? '' : 'presence',
        subBuilder: Presence.$_createMessage)
    ..aOM<Leave>(6, _omitFieldNames ? '' : 'leave',
        subBuilder: Leave.$_createMessage)
    ..aOM<DismissRecap>(7, _omitFieldNames ? '' : 'dismissRecap',
        subBuilder: DismissRecap.$_createMessage)
    ..aOM<MeldsChosen>(8, _omitFieldNames ? '' : 'meldsChosen',
        subBuilder: MeldsChosen.$_createMessage)
    ..aOM<DismissRoundSummary>(9, _omitFieldNames ? '' : 'dismissRoundSummary',
        subBuilder: DismissRoundSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientMessage copyWith(void Function(ClientMessage) updates) =>
      super.copyWith((message) => updates(message as ClientMessage))
          as ClientMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClientMessage() / ClientMessage.new instead')
  static ClientMessage create() => ClientMessage._();
  static $pb.GeneratedMessage $_createMessage() => ClientMessage._();
  @$core.override
  ClientMessage createEmptyInstance() => ClientMessage._();
  @$core.pragma('dart2js:noInline')
  static ClientMessage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientMessage>(
          ClientMessage.$_createMessage);
  static ClientMessage? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  ClientMessage_Body whichBody() => _ClientMessage_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  void clearBody() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Hello get hello => $_getN(0);
  @$pb.TagNumber(1)
  set hello(Hello value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHello() => $_has(0);
  @$pb.TagNumber(1)
  void clearHello() => $_clearField(1);
  @$pb.TagNumber(1)
  Hello ensureHello() => $_ensure(0);

  @$pb.TagNumber(2)
  Action get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(Action value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
  @$pb.TagNumber(2)
  Action ensureAction() => $_ensure(1);

  @$pb.TagNumber(3)
  ProposeRematch get proposeRematch => $_getN(2);
  @$pb.TagNumber(3)
  set proposeRematch(ProposeRematch value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProposeRematch() => $_has(2);
  @$pb.TagNumber(3)
  void clearProposeRematch() => $_clearField(3);
  @$pb.TagNumber(3)
  ProposeRematch ensureProposeRematch() => $_ensure(2);

  @$pb.TagNumber(4)
  AnswerRematch get answerRematch => $_getN(3);
  @$pb.TagNumber(4)
  set answerRematch(AnswerRematch value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAnswerRematch() => $_has(3);
  @$pb.TagNumber(4)
  void clearAnswerRematch() => $_clearField(4);
  @$pb.TagNumber(4)
  AnswerRematch ensureAnswerRematch() => $_ensure(3);

  @$pb.TagNumber(5)
  Presence get presence => $_getN(4);
  @$pb.TagNumber(5)
  set presence(Presence value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPresence() => $_has(4);
  @$pb.TagNumber(5)
  void clearPresence() => $_clearField(5);
  @$pb.TagNumber(5)
  Presence ensurePresence() => $_ensure(4);

  @$pb.TagNumber(6)
  Leave get leave => $_getN(5);
  @$pb.TagNumber(6)
  set leave(Leave value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLeave() => $_has(5);
  @$pb.TagNumber(6)
  void clearLeave() => $_clearField(6);
  @$pb.TagNumber(6)
  Leave ensureLeave() => $_ensure(5);

  @$pb.TagNumber(7)
  DismissRecap get dismissRecap => $_getN(6);
  @$pb.TagNumber(7)
  set dismissRecap(DismissRecap value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDismissRecap() => $_has(6);
  @$pb.TagNumber(7)
  void clearDismissRecap() => $_clearField(7);
  @$pb.TagNumber(7)
  DismissRecap ensureDismissRecap() => $_ensure(6);

  @$pb.TagNumber(8)
  MeldsChosen get meldsChosen => $_getN(7);
  @$pb.TagNumber(8)
  set meldsChosen(MeldsChosen value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasMeldsChosen() => $_has(7);
  @$pb.TagNumber(8)
  void clearMeldsChosen() => $_clearField(8);
  @$pb.TagNumber(8)
  MeldsChosen ensureMeldsChosen() => $_ensure(7);

  @$pb.TagNumber(9)
  DismissRoundSummary get dismissRoundSummary => $_getN(8);
  @$pb.TagNumber(9)
  set dismissRoundSummary(DismissRoundSummary value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDismissRoundSummary() => $_has(8);
  @$pb.TagNumber(9)
  void clearDismissRoundSummary() => $_clearField(9);
  @$pb.TagNumber(9)
  DismissRoundSummary ensureDismissRoundSummary() => $_ensure(8);
}

class Welcome extends $pb.GeneratedMessage {
  factory Welcome({
    $core.int? seat,
    $core.String? gameId,
  }) {
    final result = Welcome._();
    if (seat != null) result.seat = seat;
    if (gameId != null) result.gameId = gameId;
    return result;
  }

  Welcome._();

  factory Welcome.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Welcome()..mergeFromBuffer(data, registry);
  factory Welcome.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Welcome()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Welcome',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Welcome.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seat', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'gameId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Welcome clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Welcome copyWith(void Function(Welcome) updates) =>
      super.copyWith((message) => updates(message as Welcome)) as Welcome;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Welcome() / Welcome.new instead')
  static Welcome create() => Welcome._();
  static $pb.GeneratedMessage $_createMessage() => Welcome._();
  @$core.override
  Welcome createEmptyInstance() => Welcome._();
  @$core.pragma('dart2js:noInline')
  static Welcome getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Welcome>(Welcome.$_createMessage);
  static Welcome? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seat => $_getIZ(0);
  @$pb.TagNumber(1)
  set seat($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeat() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeat() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gameId => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGameId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameId() => $_clearField(2);
}

class Rejected extends $pb.GeneratedMessage {
  factory Rejected({
    Rejected_Reason? reason,
  }) {
    final result = Rejected._();
    if (reason != null) result.reason = reason;
    return result;
  }

  Rejected._();

  factory Rejected.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Rejected()..mergeFromBuffer(data, registry);
  factory Rejected.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Rejected()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Rejected',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Rejected.$_createMessage)
    ..aE<Rejected_Reason>(1, _omitFieldNames ? '' : 'reason',
        enumValues: Rejected_Reason.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rejected clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rejected copyWith(void Function(Rejected) updates) =>
      super.copyWith((message) => updates(message as Rejected)) as Rejected;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Rejected() / Rejected.new instead')
  static Rejected create() => Rejected._();
  static $pb.GeneratedMessage $_createMessage() => Rejected._();
  @$core.override
  Rejected createEmptyInstance() => Rejected._();
  @$core.pragma('dart2js:noInline')
  static Rejected getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Rejected>(Rejected.$_createMessage);
  static Rejected? _defaultInstance;

  @$pb.TagNumber(1)
  Rejected_Reason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason(Rejected_Reason value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);
}

class Trick extends $pb.GeneratedMessage {
  factory Trick({
    $core.int? leader,
    $core.Iterable<$core.int>? cards,
  }) {
    final result = Trick._();
    if (leader != null) result.leader = leader;
    if (cards != null) result.cards.addAll(cards);
    return result;
  }

  Trick._();

  factory Trick.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Trick()..mergeFromBuffer(data, registry);
  factory Trick.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Trick()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Trick',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Trick.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'leader', fieldType: $pb.PbFieldType.OU3)
    ..p<$core.int>(2, _omitFieldNames ? '' : 'cards', $pb.PbFieldType.KU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trick clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trick copyWith(void Function(Trick) updates) =>
      super.copyWith((message) => updates(message as Trick)) as Trick;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Trick() / Trick.new instead')
  static Trick create() => Trick._();
  static $pb.GeneratedMessage $_createMessage() => Trick._();
  @$core.override
  Trick createEmptyInstance() => Trick._();
  @$core.pragma('dart2js:noInline')
  static Trick getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Trick>(Trick.$_createMessage);
  static Trick? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get leader => $_getIZ(0);
  @$pb.TagNumber(1)
  set leader($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLeader() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeader() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.int> get cards => $_getList(1);
}

class SeatMelds extends $pb.GeneratedMessage {
  factory SeatMelds({
    $core.Iterable<$core.int>? announcedValues,
    $core.Iterable<$fixnum.Int64>? revealed,
  }) {
    final result = SeatMelds._();
    if (announcedValues != null) result.announcedValues.addAll(announcedValues);
    if (revealed != null) result.revealed.addAll(revealed);
    return result;
  }

  SeatMelds._();

  factory SeatMelds.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeatMelds()..mergeFromBuffer(data, registry);
  factory SeatMelds.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeatMelds()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeatMelds',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: SeatMelds.$_createMessage)
    ..p<$core.int>(
        1, _omitFieldNames ? '' : 'announcedValues', $pb.PbFieldType.KU3)
    ..p<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'revealed', $pb.PbFieldType.KU6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeatMelds clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeatMelds copyWith(void Function(SeatMelds) updates) =>
      super.copyWith((message) => updates(message as SeatMelds)) as SeatMelds;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SeatMelds() / SeatMelds.new instead')
  static SeatMelds create() => SeatMelds._();
  static $pb.GeneratedMessage $_createMessage() => SeatMelds._();
  @$core.override
  SeatMelds createEmptyInstance() => SeatMelds._();
  @$core.pragma('dart2js:noInline')
  static SeatMelds getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeatMelds>(SeatMelds.$_createMessage);
  static SeatMelds? _defaultInstance;

  /// Values of all the melds announced by the seat.
  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get announcedValues => $_getList(0);

  /// Cards of the melds the viewer is allowed to see.
  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get revealed => $_getList(1);
}

class RematchProposal extends $pb.GeneratedMessage {
  factory RematchProposal({
    $core.int? proposedBy,
    $core.bool? sameCards,
  }) {
    final result = RematchProposal._();
    if (proposedBy != null) result.proposedBy = proposedBy;
    if (sameCards != null) result.sameCards = sameCards;
    return result;
  }

  RematchProposal._();

  factory RematchProposal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RematchProposal()..mergeFromBuffer(data, registry);
  factory RematchProposal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RematchProposal()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RematchProposal',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: RematchProposal.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'proposedBy', fieldType: $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'sameCards')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RematchProposal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RematchProposal copyWith(void Function(RematchProposal) updates) =>
      super.copyWith((message) => updates(message as RematchProposal))
          as RematchProposal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RematchProposal() / RematchProposal.new instead')
  static RematchProposal create() => RematchProposal._();
  static $pb.GeneratedMessage $_createMessage() => RematchProposal._();
  @$core.override
  RematchProposal createEmptyInstance() => RematchProposal._();
  @$core.pragma('dart2js:noInline')
  static RematchProposal getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RematchProposal>(
          RematchProposal.$_createMessage);
  static RematchProposal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get proposedBy => $_getIZ(0);
  @$pb.TagNumber(1)
  set proposedBy($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProposedBy() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposedBy() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get sameCards => $_getBF(1);
  @$pb.TagNumber(2)
  set sameCards($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSameCards() => $_has(1);
  @$pb.TagNumber(2)
  void clearSameCards() => $_clearField(2);
}

class Blunder extends $pb.GeneratedMessage {
  factory Blunder({
    Blunder_Kind? kind,
    $core.int? seat,
    $core.int? roundIndex,
    $core.int? trickIndex,
    $fixnum.Int64? hand,
    $core.Iterable<$core.int>? trick,
    TrumpMode? mode,
    $core.double? pointsLost,
    $core.int? playedCard,
    $core.int? bestCard,
    TrumpMode? chosenTrump,
    TrumpMode? bestTrump,
    $core.Iterable<$fixnum.Int64>? missedMelds,
  }) {
    final result = Blunder._();
    if (kind != null) result.kind = kind;
    if (seat != null) result.seat = seat;
    if (roundIndex != null) result.roundIndex = roundIndex;
    if (trickIndex != null) result.trickIndex = trickIndex;
    if (hand != null) result.hand = hand;
    if (trick != null) result.trick.addAll(trick);
    if (mode != null) result.mode = mode;
    if (pointsLost != null) result.pointsLost = pointsLost;
    if (playedCard != null) result.playedCard = playedCard;
    if (bestCard != null) result.bestCard = bestCard;
    if (chosenTrump != null) result.chosenTrump = chosenTrump;
    if (bestTrump != null) result.bestTrump = bestTrump;
    if (missedMelds != null) result.missedMelds.addAll(missedMelds);
    return result;
  }

  Blunder._();

  factory Blunder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Blunder()..mergeFromBuffer(data, registry);
  factory Blunder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Blunder()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Blunder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Blunder.$_createMessage)
    ..aE<Blunder_Kind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: Blunder_Kind.values)
    ..aI(2, _omitFieldNames ? '' : 'seat', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'roundIndex', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'trickIndex')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'hand', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..p<$core.int>(6, _omitFieldNames ? '' : 'trick', $pb.PbFieldType.KU3)
    ..aE<TrumpMode>(7, _omitFieldNames ? '' : 'mode',
        enumValues: TrumpMode.values)
    ..aD(8, _omitFieldNames ? '' : 'pointsLost')
    ..aI(9, _omitFieldNames ? '' : 'playedCard')
    ..aI(10, _omitFieldNames ? '' : 'bestCard')
    ..aE<TrumpMode>(11, _omitFieldNames ? '' : 'chosenTrump',
        enumValues: TrumpMode.values)
    ..aE<TrumpMode>(12, _omitFieldNames ? '' : 'bestTrump',
        enumValues: TrumpMode.values)
    ..p<$fixnum.Int64>(
        13, _omitFieldNames ? '' : 'missedMelds', $pb.PbFieldType.KU6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Blunder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Blunder copyWith(void Function(Blunder) updates) =>
      super.copyWith((message) => updates(message as Blunder)) as Blunder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Blunder() / Blunder.new instead')
  static Blunder create() => Blunder._();
  static $pb.GeneratedMessage $_createMessage() => Blunder._();
  @$core.override
  Blunder createEmptyInstance() => Blunder._();
  @$core.pragma('dart2js:noInline')
  static Blunder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Blunder>(Blunder.$_createMessage);
  static Blunder? _defaultInstance;

  @$pb.TagNumber(1)
  Blunder_Kind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(Blunder_Kind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get seat => $_getIZ(1);
  @$pb.TagNumber(2)
  set seat($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeat() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeat() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get roundIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set roundIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoundIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoundIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get trickIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set trickIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrickIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrickIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get hand => $_getI64(4);
  @$pb.TagNumber(5)
  set hand($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHand() => $_has(4);
  @$pb.TagNumber(5)
  void clearHand() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.int> get trick => $_getList(5);

  @$pb.TagNumber(7)
  TrumpMode get mode => $_getN(6);
  @$pb.TagNumber(7)
  set mode(TrumpMode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get pointsLost => $_getN(7);
  @$pb.TagNumber(8)
  set pointsLost($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPointsLost() => $_has(7);
  @$pb.TagNumber(8)
  void clearPointsLost() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get playedCard => $_getIZ(8);
  @$pb.TagNumber(9)
  set playedCard($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPlayedCard() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlayedCard() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get bestCard => $_getIZ(9);
  @$pb.TagNumber(10)
  set bestCard($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBestCard() => $_has(9);
  @$pb.TagNumber(10)
  void clearBestCard() => $_clearField(10);

  /// TRUMP_MODE_NONE means chibrer.
  @$pb.TagNumber(11)
  TrumpMode get chosenTrump => $_getN(10);
  @$pb.TagNumber(11)
  set chosenTrump(TrumpMode value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasChosenTrump() => $_has(10);
  @$pb.TagNumber(11)
  void clearChosenTrump() => $_clearField(11);

  @$pb.TagNumber(12)
  TrumpMode get bestTrump => $_getN(11);
  @$pb.TagNumber(12)
  set bestTrump(TrumpMode value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasBestTrump() => $_has(11);
  @$pb.TagNumber(12)
  void clearBestTrump() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$fixnum.Int64> get missedMelds => $_getList(12);
}

class Insights extends $pb.GeneratedMessage {
  factory Insights({
    $core.Iterable<Blunder>? blunders,
  }) {
    final result = Insights._();
    if (blunders != null) result.blunders.addAll(blunders);
    return result;
  }

  Insights._();

  factory Insights.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Insights()..mergeFromBuffer(data, registry);
  factory Insights.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Insights()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Insights',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Insights.$_createMessage)
    ..pPM<Blunder>(1, _omitFieldNames ? '' : 'blunders',
        subBuilder: Blunder.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Insights clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Insights copyWith(void Function(Insights) updates) =>
      super.copyWith((message) => updates(message as Insights)) as Insights;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Insights() / Insights.new instead')
  static Insights create() => Insights._();
  static $pb.GeneratedMessage $_createMessage() => Insights._();
  @$core.override
  Insights createEmptyInstance() => Insights._();
  @$core.pragma('dart2js:noInline')
  static Insights getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Insights>(Insights.$_createMessage);
  static Insights? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Blunder> get blunders => $_getList(0);
}

/// Everything a seat may see. Sent after every change: it is small, and a
/// reconnecting phone needs nothing else.
class TableSnapshot extends $pb.GeneratedMessage {
  factory TableSnapshot({
    $core.int? viewer,
    $core.Iterable<$core.String>? nicknames,
    GameOptions? options,
    TableSnapshot_Phase? phase,
    $core.int? roundIndex,
    $fixnum.Int64? hand,
    TrumpMode? mode,
    $core.int? trumpChooser,
    $core.bool? chibred,
    $core.int? seatToAct,
    $core.Iterable<Trick>? completedTricks,
    Trick? currentTrick,
    $core.Iterable<SeatMelds>? melds,
    $core.int? stoeckSeat,
    $core.Iterable<$core.int>? scores,
    $core.Iterable<$core.int>? roundPoints,
    $core.int? winningTeam,
    $core.String? pausedFor,
    RematchProposal? rematch,
    Insights? insights,
    $core.int? trickHoldMs,
    $core.Iterable<$core.int>? recapFor,
    $core.Iterable<$core.int>? meldChoiceFor,
    $core.bool? assistance,
    $core.bool? sortByTrump,
    $core.bool? autoAnnounce,
    $core.int? thinkingTimeMs,
    $core.Iterable<$core.int>? roundSummaryFor,
  }) {
    final result = TableSnapshot._();
    if (viewer != null) result.viewer = viewer;
    if (nicknames != null) result.nicknames.addAll(nicknames);
    if (options != null) result.options = options;
    if (phase != null) result.phase = phase;
    if (roundIndex != null) result.roundIndex = roundIndex;
    if (hand != null) result.hand = hand;
    if (mode != null) result.mode = mode;
    if (trumpChooser != null) result.trumpChooser = trumpChooser;
    if (chibred != null) result.chibred = chibred;
    if (seatToAct != null) result.seatToAct = seatToAct;
    if (completedTricks != null) result.completedTricks.addAll(completedTricks);
    if (currentTrick != null) result.currentTrick = currentTrick;
    if (melds != null) result.melds.addAll(melds);
    if (stoeckSeat != null) result.stoeckSeat = stoeckSeat;
    if (scores != null) result.scores.addAll(scores);
    if (roundPoints != null) result.roundPoints.addAll(roundPoints);
    if (winningTeam != null) result.winningTeam = winningTeam;
    if (pausedFor != null) result.pausedFor = pausedFor;
    if (rematch != null) result.rematch = rematch;
    if (insights != null) result.insights = insights;
    if (trickHoldMs != null) result.trickHoldMs = trickHoldMs;
    if (recapFor != null) result.recapFor.addAll(recapFor);
    if (meldChoiceFor != null) result.meldChoiceFor.addAll(meldChoiceFor);
    if (assistance != null) result.assistance = assistance;
    if (sortByTrump != null) result.sortByTrump = sortByTrump;
    if (autoAnnounce != null) result.autoAnnounce = autoAnnounce;
    if (thinkingTimeMs != null) result.thinkingTimeMs = thinkingTimeMs;
    if (roundSummaryFor != null) result.roundSummaryFor.addAll(roundSummaryFor);
    return result;
  }

  TableSnapshot._();

  factory TableSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TableSnapshot()..mergeFromBuffer(data, registry);
  factory TableSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TableSnapshot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TableSnapshot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: TableSnapshot.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'viewer', fieldType: $pb.PbFieldType.OU3)
    ..pPS(2, _omitFieldNames ? '' : 'nicknames')
    ..aOM<GameOptions>(3, _omitFieldNames ? '' : 'options',
        subBuilder: GameOptions.$_createMessage)
    ..aE<TableSnapshot_Phase>(5, _omitFieldNames ? '' : 'phase',
        enumValues: TableSnapshot_Phase.values)
    ..aI(6, _omitFieldNames ? '' : 'roundIndex', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'hand', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<TrumpMode>(8, _omitFieldNames ? '' : 'mode',
        enumValues: TrumpMode.values)
    ..aI(9, _omitFieldNames ? '' : 'trumpChooser',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(10, _omitFieldNames ? '' : 'chibred')
    ..aI(11, _omitFieldNames ? '' : 'seatToAct')
    ..pPM<Trick>(12, _omitFieldNames ? '' : 'completedTricks',
        subBuilder: Trick.$_createMessage)
    ..aOM<Trick>(13, _omitFieldNames ? '' : 'currentTrick',
        subBuilder: Trick.$_createMessage)
    ..pPM<SeatMelds>(14, _omitFieldNames ? '' : 'melds',
        subBuilder: SeatMelds.$_createMessage)
    ..aI(15, _omitFieldNames ? '' : 'stoeckSeat')
    ..p<$core.int>(16, _omitFieldNames ? '' : 'scores', $pb.PbFieldType.K3)
    ..p<$core.int>(17, _omitFieldNames ? '' : 'roundPoints', $pb.PbFieldType.K3)
    ..aI(18, _omitFieldNames ? '' : 'winningTeam')
    ..aOS(19, _omitFieldNames ? '' : 'pausedFor')
    ..aOM<RematchProposal>(20, _omitFieldNames ? '' : 'rematch',
        subBuilder: RematchProposal.$_createMessage)
    ..aOM<Insights>(21, _omitFieldNames ? '' : 'insights',
        subBuilder: Insights.$_createMessage)
    ..aI(22, _omitFieldNames ? '' : 'trickHoldMs',
        fieldType: $pb.PbFieldType.OU3)
    ..p<$core.int>(23, _omitFieldNames ? '' : 'recapFor', $pb.PbFieldType.KU3)
    ..p<$core.int>(
        24, _omitFieldNames ? '' : 'meldChoiceFor', $pb.PbFieldType.KU3)
    ..aOB(25, _omitFieldNames ? '' : 'assistance')
    ..aOB(26, _omitFieldNames ? '' : 'sortByTrump')
    ..aOB(27, _omitFieldNames ? '' : 'autoAnnounce')
    ..aI(28, _omitFieldNames ? '' : 'thinkingTimeMs',
        fieldType: $pb.PbFieldType.OU3)
    ..p<$core.int>(
        29, _omitFieldNames ? '' : 'roundSummaryFor', $pb.PbFieldType.KU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TableSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TableSnapshot copyWith(void Function(TableSnapshot) updates) =>
      super.copyWith((message) => updates(message as TableSnapshot))
          as TableSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TableSnapshot() / TableSnapshot.new instead')
  static TableSnapshot create() => TableSnapshot._();
  static $pb.GeneratedMessage $_createMessage() => TableSnapshot._();
  @$core.override
  TableSnapshot createEmptyInstance() => TableSnapshot._();
  @$core.pragma('dart2js:noInline')
  static TableSnapshot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TableSnapshot>(
          TableSnapshot.$_createMessage);
  static TableSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get viewer => $_getIZ(0);
  @$pb.TagNumber(1)
  set viewer($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasViewer() => $_has(0);
  @$pb.TagNumber(1)
  void clearViewer() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get nicknames => $_getList(1);

  @$pb.TagNumber(3)
  GameOptions get options => $_getN(2);
  @$pb.TagNumber(3)
  set options(GameOptions value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOptions() => $_has(2);
  @$pb.TagNumber(3)
  void clearOptions() => $_clearField(3);
  @$pb.TagNumber(3)
  GameOptions ensureOptions() => $_ensure(2);

  @$pb.TagNumber(5)
  TableSnapshot_Phase get phase => $_getN(3);
  @$pb.TagNumber(5)
  set phase(TableSnapshot_Phase value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPhase() => $_has(3);
  @$pb.TagNumber(5)
  void clearPhase() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get roundIndex => $_getIZ(4);
  @$pb.TagNumber(6)
  set roundIndex($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(6)
  $core.bool hasRoundIndex() => $_has(4);
  @$pb.TagNumber(6)
  void clearRoundIndex() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get hand => $_getI64(5);
  @$pb.TagNumber(7)
  set hand($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(7)
  $core.bool hasHand() => $_has(5);
  @$pb.TagNumber(7)
  void clearHand() => $_clearField(7);

  @$pb.TagNumber(8)
  TrumpMode get mode => $_getN(6);
  @$pb.TagNumber(8)
  set mode(TrumpMode value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasMode() => $_has(6);
  @$pb.TagNumber(8)
  void clearMode() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get trumpChooser => $_getIZ(7);
  @$pb.TagNumber(9)
  set trumpChooser($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(9)
  $core.bool hasTrumpChooser() => $_has(7);
  @$pb.TagNumber(9)
  void clearTrumpChooser() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get chibred => $_getBF(8);
  @$pb.TagNumber(10)
  set chibred($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(10)
  $core.bool hasChibred() => $_has(8);
  @$pb.TagNumber(10)
  void clearChibred() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get seatToAct => $_getIZ(9);
  @$pb.TagNumber(11)
  set seatToAct($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(11)
  $core.bool hasSeatToAct() => $_has(9);
  @$pb.TagNumber(11)
  void clearSeatToAct() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<Trick> get completedTricks => $_getList(10);

  @$pb.TagNumber(13)
  Trick get currentTrick => $_getN(11);
  @$pb.TagNumber(13)
  set currentTrick(Trick value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCurrentTrick() => $_has(11);
  @$pb.TagNumber(13)
  void clearCurrentTrick() => $_clearField(13);
  @$pb.TagNumber(13)
  Trick ensureCurrentTrick() => $_ensure(11);

  @$pb.TagNumber(14)
  $pb.PbList<SeatMelds> get melds => $_getList(12);

  @$pb.TagNumber(15)
  $core.int get stoeckSeat => $_getIZ(13);
  @$pb.TagNumber(15)
  set stoeckSeat($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(15)
  $core.bool hasStoeckSeat() => $_has(13);
  @$pb.TagNumber(15)
  void clearStoeckSeat() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<$core.int> get scores => $_getList(14);

  @$pb.TagNumber(17)
  $pb.PbList<$core.int> get roundPoints => $_getList(15);

  @$pb.TagNumber(18)
  $core.int get winningTeam => $_getIZ(16);
  @$pb.TagNumber(18)
  set winningTeam($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(18)
  $core.bool hasWinningTeam() => $_has(16);
  @$pb.TagNumber(18)
  void clearWinningTeam() => $_clearField(18);

  /// Nickname of the player the game waits for; empty when not paused.
  @$pb.TagNumber(19)
  $core.String get pausedFor => $_getSZ(17);
  @$pb.TagNumber(19)
  set pausedFor($core.String value) => $_setString(17, value);
  @$pb.TagNumber(19)
  $core.bool hasPausedFor() => $_has(17);
  @$pb.TagNumber(19)
  void clearPausedFor() => $_clearField(19);

  @$pb.TagNumber(20)
  RematchProposal get rematch => $_getN(18);
  @$pb.TagNumber(20)
  set rematch(RematchProposal value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasRematch() => $_has(18);
  @$pb.TagNumber(20)
  void clearRematch() => $_clearField(20);
  @$pb.TagNumber(20)
  RematchProposal ensureRematch() => $_ensure(18);

  @$pb.TagNumber(21)
  Insights get insights => $_getN(19);
  @$pb.TagNumber(21)
  set insights(Insights value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasInsights() => $_has(19);
  @$pb.TagNumber(21)
  void clearInsights() => $_clearField(21);
  @$pb.TagNumber(21)
  Insights ensureInsights() => $_ensure(19);

  /// How long a complete trick stays before sliding to its winner.
  @$pb.TagNumber(22)
  $core.int get trickHoldMs => $_getIZ(20);
  @$pb.TagNumber(22)
  set trickHoldMs($core.int value) => $_setUnsignedInt32(20, value);
  @$pb.TagNumber(22)
  $core.bool hasTrickHoldMs() => $_has(20);
  @$pb.TagNumber(22)
  void clearTrickHoldMs() => $_clearField(22);

  /// Seats still reading the recap of the announcements; nobody plays until
  /// it is empty.
  @$pb.TagNumber(23)
  $pb.PbList<$core.int> get recapFor => $_getList(21);

  /// Humans still choosing their melds; the bots wait for them.
  @$pb.TagNumber(24)
  $pb.PbList<$core.int> get meldChoiceFor => $_getList(22);

  /// Whether the play screen shows the "Jouer pour moi" and "Cartes jouées"
  /// buttons.
  @$pb.TagNumber(25)
  $core.bool get assistance => $_getBF(23);
  @$pb.TagNumber(25)
  set assistance($core.bool value) => $_setBool(23, value);
  @$pb.TagNumber(25)
  $core.bool hasAssistance() => $_has(23);
  @$pb.TagNumber(25)
  void clearAssistance() => $_clearField(25);

  /// Whether hands are sorted by trump (trump first, by strength) rather
  /// than in the fixed order ♥ ♠ ♦ ♣.
  @$pb.TagNumber(26)
  $core.bool get sortByTrump => $_getBF(24);
  @$pb.TagNumber(26)
  set sortByTrump($core.bool value) => $_setBool(24, value);
  @$pb.TagNumber(26)
  $core.bool hasSortByTrump() => $_has(24);
  @$pb.TagNumber(26)
  void clearSortByTrump() => $_clearField(26);

  /// Whether Stöck is announced automatically and the melds are offered in a
  /// pop-up rather than selected card by card.
  @$pb.TagNumber(27)
  $core.bool get autoAnnounce => $_getBF(25);
  @$pb.TagNumber(27)
  set autoAnnounce($core.bool value) => $_setBool(25, value);
  @$pb.TagNumber(27)
  $core.bool hasAutoAnnounce() => $_has(25);
  @$pb.TagNumber(27)
  void clearAutoAnnounce() => $_clearField(27);

  /// How long a computer player thinks per decision, before the minimum
  /// delay; each phone turns it into a number of iterations for its speed.
  @$pb.TagNumber(28)
  $core.int get thinkingTimeMs => $_getIZ(26);
  @$pb.TagNumber(28)
  set thinkingTimeMs($core.int value) => $_setUnsignedInt32(26, value);
  @$pb.TagNumber(28)
  $core.bool hasThinkingTimeMs() => $_has(26);
  @$pb.TagNumber(28)
  void clearThinkingTimeMs() => $_clearField(28);

  /// Seats still reading the summary of the round; the next round waits
  /// until it is empty.
  @$pb.TagNumber(29)
  $pb.PbList<$core.int> get roundSummaryFor => $_getList(27);
}

class ActionRejected extends $pb.GeneratedMessage {
  factory ActionRejected({
    $core.String? reason,
  }) {
    final result = ActionRejected._();
    if (reason != null) result.reason = reason;
    return result;
  }

  ActionRejected._();

  factory ActionRejected.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionRejected()..mergeFromBuffer(data, registry);
  factory ActionRejected.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionRejected()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionRejected',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: ActionRejected.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionRejected clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionRejected copyWith(void Function(ActionRejected) updates) =>
      super.copyWith((message) => updates(message as ActionRejected))
          as ActionRejected;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActionRejected() / ActionRejected.new instead')
  static ActionRejected create() => ActionRejected._();
  static $pb.GeneratedMessage $_createMessage() => ActionRejected._();
  @$core.override
  ActionRejected createEmptyInstance() => ActionRejected._();
  @$core.pragma('dart2js:noInline')
  static ActionRejected getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionRejected>(
          ActionRejected.$_createMessage);
  static ActionRejected? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);
}

/// The host ended the game.
class Closed extends $pb.GeneratedMessage {
  factory Closed() => Closed._();

  Closed._();

  factory Closed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Closed()..mergeFromBuffer(data, registry);
  factory Closed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Closed()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Closed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Closed.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Closed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Closed copyWith(void Function(Closed) updates) =>
      super.copyWith((message) => updates(message as Closed)) as Closed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Closed() / Closed.new instead')
  static Closed create() => Closed._();
  static $pb.GeneratedMessage $_createMessage() => Closed._();
  @$core.override
  Closed createEmptyInstance() => Closed._();
  @$core.pragma('dart2js:noInline')
  static Closed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Closed>(Closed.$_createMessage);
  static Closed? _defaultInstance;
}

enum HostMessage_Body {
  welcome,
  rejected,
  table,
  actionRejected,
  closed,
  notSet
}

class HostMessage extends $pb.GeneratedMessage {
  factory HostMessage({
    Welcome? welcome,
    Rejected? rejected,
    TableSnapshot? table,
    ActionRejected? actionRejected,
    Closed? closed,
  }) {
    final result = HostMessage._();
    if (welcome != null) result.welcome = welcome;
    if (rejected != null) result.rejected = rejected;
    if (table != null) result.table = table;
    if (actionRejected != null) result.actionRejected = actionRejected;
    if (closed != null) result.closed = closed;
    return result;
  }

  HostMessage._();

  factory HostMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostMessage()..mergeFromBuffer(data, registry);
  factory HostMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HostMessage()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, HostMessage_Body> _HostMessage_BodyByTag = {
    1: HostMessage_Body.welcome,
    2: HostMessage_Body.rejected,
    3: HostMessage_Body.table,
    4: HostMessage_Body.actionRejected,
    5: HostMessage_Body.closed,
    0: HostMessage_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HostMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: HostMessage.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<Welcome>(1, _omitFieldNames ? '' : 'welcome',
        subBuilder: Welcome.$_createMessage)
    ..aOM<Rejected>(2, _omitFieldNames ? '' : 'rejected',
        subBuilder: Rejected.$_createMessage)
    ..aOM<TableSnapshot>(3, _omitFieldNames ? '' : 'table',
        subBuilder: TableSnapshot.$_createMessage)
    ..aOM<ActionRejected>(4, _omitFieldNames ? '' : 'actionRejected',
        subBuilder: ActionRejected.$_createMessage)
    ..aOM<Closed>(5, _omitFieldNames ? '' : 'closed',
        subBuilder: Closed.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HostMessage copyWith(void Function(HostMessage) updates) =>
      super.copyWith((message) => updates(message as HostMessage))
          as HostMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HostMessage() / HostMessage.new instead')
  static HostMessage create() => HostMessage._();
  static $pb.GeneratedMessage $_createMessage() => HostMessage._();
  @$core.override
  HostMessage createEmptyInstance() => HostMessage._();
  @$core.pragma('dart2js:noInline')
  static HostMessage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HostMessage>(
          HostMessage.$_createMessage);
  static HostMessage? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  HostMessage_Body whichBody() => _HostMessage_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearBody() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Welcome get welcome => $_getN(0);
  @$pb.TagNumber(1)
  set welcome(Welcome value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWelcome() => $_has(0);
  @$pb.TagNumber(1)
  void clearWelcome() => $_clearField(1);
  @$pb.TagNumber(1)
  Welcome ensureWelcome() => $_ensure(0);

  @$pb.TagNumber(2)
  Rejected get rejected => $_getN(1);
  @$pb.TagNumber(2)
  set rejected(Rejected value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRejected() => $_has(1);
  @$pb.TagNumber(2)
  void clearRejected() => $_clearField(2);
  @$pb.TagNumber(2)
  Rejected ensureRejected() => $_ensure(1);

  @$pb.TagNumber(3)
  TableSnapshot get table => $_getN(2);
  @$pb.TagNumber(3)
  set table(TableSnapshot value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTable() => $_has(2);
  @$pb.TagNumber(3)
  void clearTable() => $_clearField(3);
  @$pb.TagNumber(3)
  TableSnapshot ensureTable() => $_ensure(2);

  @$pb.TagNumber(4)
  ActionRejected get actionRejected => $_getN(3);
  @$pb.TagNumber(4)
  set actionRejected(ActionRejected value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasActionRejected() => $_has(3);
  @$pb.TagNumber(4)
  void clearActionRejected() => $_clearField(4);
  @$pb.TagNumber(4)
  ActionRejected ensureActionRejected() => $_ensure(3);

  @$pb.TagNumber(5)
  Closed get closed => $_getN(4);
  @$pb.TagNumber(5)
  set closed(Closed value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasClosed() => $_has(4);
  @$pb.TagNumber(5)
  void clearClosed() => $_clearField(5);
  @$pb.TagNumber(5)
  Closed ensureClosed() => $_ensure(4);
}

class Round extends $pb.GeneratedMessage {
  factory Round({
    $core.Iterable<$fixnum.Int64>? deal,
    $core.int? trumpChooser,
    $core.Iterable<Action>? actions,
  }) {
    final result = Round._();
    if (deal != null) result.deal.addAll(deal);
    if (trumpChooser != null) result.trumpChooser = trumpChooser;
    if (actions != null) result.actions.addAll(actions);
    return result;
  }

  Round._();

  factory Round.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Round()..mergeFromBuffer(data, registry);
  factory Round.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Round()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Round',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: Round.$_createMessage)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'deal', $pb.PbFieldType.KU6)
    ..aI(2, _omitFieldNames ? '' : 'trumpChooser',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<Action>(3, _omitFieldNames ? '' : 'actions',
        subBuilder: Action.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Round clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Round copyWith(void Function(Round) updates) =>
      super.copyWith((message) => updates(message as Round)) as Round;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Round() / Round.new instead')
  static Round create() => Round._();
  static $pb.GeneratedMessage $_createMessage() => Round._();
  @$core.override
  Round createEmptyInstance() => Round._();
  @$core.pragma('dart2js:noInline')
  static Round getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Round>(Round.$_createMessage);
  static Round? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get deal => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get trumpChooser => $_getIZ(1);
  @$pb.TagNumber(2)
  set trumpChooser($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrumpChooser() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrumpChooser() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Action> get actions => $_getList(2);
}

class GameRecord extends $pb.GeneratedMessage {
  factory GameRecord({
    GameOptions? options,
    $core.Iterable<Round>? rounds,
  }) {
    final result = GameRecord._();
    if (options != null) result.options = options;
    if (rounds != null) result.rounds.addAll(rounds);
    return result;
  }

  GameRecord._();

  factory GameRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GameRecord()..mergeFromBuffer(data, registry);
  factory GameRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GameRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GameRecord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: GameRecord.$_createMessage)
    ..aOM<GameOptions>(1, _omitFieldNames ? '' : 'options',
        subBuilder: GameOptions.$_createMessage)
    ..pPM<Round>(2, _omitFieldNames ? '' : 'rounds',
        subBuilder: Round.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameRecord copyWith(void Function(GameRecord) updates) =>
      super.copyWith((message) => updates(message as GameRecord)) as GameRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GameRecord() / GameRecord.new instead')
  static GameRecord create() => GameRecord._();
  static $pb.GeneratedMessage $_createMessage() => GameRecord._();
  @$core.override
  GameRecord createEmptyInstance() => GameRecord._();
  @$core.pragma('dart2js:noInline')
  static GameRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GameRecord>(GameRecord.$_createMessage);
  static GameRecord? _defaultInstance;

  @$pb.TagNumber(1)
  GameOptions get options => $_getN(0);
  @$pb.TagNumber(1)
  set options(GameOptions value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOptions() => $_has(0);
  @$pb.TagNumber(1)
  void clearOptions() => $_clearField(1);
  @$pb.TagNumber(1)
  GameOptions ensureOptions() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Round> get rounds => $_getList(1);
}

/// Saved by the host after every action so a crashed app can resume.
class SavedGame extends $pb.GeneratedMessage {
  factory SavedGame({
    $core.String? gameId,
    $core.String? gameName,
    $core.Iterable<$core.String>? nicknames,
    $core.String? joinerInstallationId,
    GameRecord? record,
    $core.int? trickHoldMs,
    $core.bool? assistance,
    $core.bool? sortByTrump,
    $core.bool? autoAnnounce,
    $core.int? thinkingTimeMs,
  }) {
    final result = SavedGame._();
    if (gameId != null) result.gameId = gameId;
    if (gameName != null) result.gameName = gameName;
    if (nicknames != null) result.nicknames.addAll(nicknames);
    if (joinerInstallationId != null)
      result.joinerInstallationId = joinerInstallationId;
    if (record != null) result.record = record;
    if (trickHoldMs != null) result.trickHoldMs = trickHoldMs;
    if (assistance != null) result.assistance = assistance;
    if (sortByTrump != null) result.sortByTrump = sortByTrump;
    if (autoAnnounce != null) result.autoAnnounce = autoAnnounce;
    if (thinkingTimeMs != null) result.thinkingTimeMs = thinkingTimeMs;
    return result;
  }

  SavedGame._();

  factory SavedGame.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SavedGame()..mergeFromBuffer(data, registry);
  factory SavedGame.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SavedGame()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SavedGame',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chibre'),
      createEmptyInstance: SavedGame.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'gameId')
    ..aOS(2, _omitFieldNames ? '' : 'gameName')
    ..pPS(3, _omitFieldNames ? '' : 'nicknames')
    ..aOS(4, _omitFieldNames ? '' : 'joinerInstallationId')
    ..aOM<GameRecord>(6, _omitFieldNames ? '' : 'record',
        subBuilder: GameRecord.$_createMessage)
    ..aI(7, _omitFieldNames ? '' : 'trickHoldMs',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(8, _omitFieldNames ? '' : 'assistance')
    ..aOB(9, _omitFieldNames ? '' : 'sortByTrump')
    ..aOB(10, _omitFieldNames ? '' : 'autoAnnounce')
    ..aI(11, _omitFieldNames ? '' : 'thinkingTimeMs',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavedGame clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SavedGame copyWith(void Function(SavedGame) updates) =>
      super.copyWith((message) => updates(message as SavedGame)) as SavedGame;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SavedGame() / SavedGame.new instead')
  static SavedGame create() => SavedGame._();
  static $pb.GeneratedMessage $_createMessage() => SavedGame._();
  @$core.override
  SavedGame createEmptyInstance() => SavedGame._();
  @$core.pragma('dart2js:noInline')
  static SavedGame getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SavedGame>(SavedGame.$_createMessage);
  static SavedGame? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gameName => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGameName() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get nicknames => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get joinerInstallationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set joinerInstallationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJoinerInstallationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinerInstallationId() => $_clearField(4);

  @$pb.TagNumber(6)
  GameRecord get record => $_getN(4);
  @$pb.TagNumber(6)
  set record(GameRecord value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRecord() => $_has(4);
  @$pb.TagNumber(6)
  void clearRecord() => $_clearField(6);
  @$pb.TagNumber(6)
  GameRecord ensureRecord() => $_ensure(4);

  @$pb.TagNumber(7)
  $core.int get trickHoldMs => $_getIZ(5);
  @$pb.TagNumber(7)
  set trickHoldMs($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(7)
  $core.bool hasTrickHoldMs() => $_has(5);
  @$pb.TagNumber(7)
  void clearTrickHoldMs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get assistance => $_getBF(6);
  @$pb.TagNumber(8)
  set assistance($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(8)
  $core.bool hasAssistance() => $_has(6);
  @$pb.TagNumber(8)
  void clearAssistance() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get sortByTrump => $_getBF(7);
  @$pb.TagNumber(9)
  set sortByTrump($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(9)
  $core.bool hasSortByTrump() => $_has(7);
  @$pb.TagNumber(9)
  void clearSortByTrump() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get autoAnnounce => $_getBF(8);
  @$pb.TagNumber(10)
  set autoAnnounce($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(10)
  $core.bool hasAutoAnnounce() => $_has(8);
  @$pb.TagNumber(10)
  void clearAutoAnnounce() => $_clearField(10);

  /// 0 in games saved before it existed: the default is used.
  @$pb.TagNumber(11)
  $core.int get thinkingTimeMs => $_getIZ(9);
  @$pb.TagNumber(11)
  set thinkingTimeMs($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(11)
  $core.bool hasThinkingTimeMs() => $_has(9);
  @$pb.TagNumber(11)
  void clearThinkingTimeMs() => $_clearField(11);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
