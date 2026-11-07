import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../game/game_defaults.dart';

/// What the app remembers on the phone: the nickname, the game defaults, a
/// random installation id (to recognise a reconnecting player, never tied to
/// a person) and the result of the speed benchmark. Nothing leaves the phone
/// except the nickname, shared with the other player of a game.
///
/// [profile] namespaces the keys so that two app instances on one computer
/// (local demo) behave like two phones.
class ProfileStore {
  ProfileStore(this._preferences, {this.profile = ''});

  static Future<ProfileStore> open({String profile = ''}) async =>
      ProfileStore(await SharedPreferences.getInstance(), profile: profile);

  final SharedPreferences _preferences;
  final String profile;

  String _key(String name) => profile.isEmpty ? name : '$profile.$name';

  String? get nickname => _preferences.getString(_key('nickname'));

  Future<void> setNickname(String nickname) =>
      _preferences.setString(_key('nickname'), nickname.trim());

  /// The options the host screen starts with.
  GameDefaults get gameDefaults {
    final saved = _preferences.getString(_key('gameDefaults'));
    if (saved == null) return const GameDefaults();
    try {
      return GameDefaults.fromJson(jsonDecode(saved) as Map<String, Object?>);
    } on FormatException {
      return const GameDefaults();
    }
  }

  Future<void> setGameDefaults(GameDefaults defaults) => _preferences.setString(
    _key('gameDefaults'),
    jsonEncode(defaults.toJson()),
  );

  String get installationId {
    final existing = _preferences.getString(_key('installationId'));
    if (existing != null) return existing;
    final random = Random.secure();
    final id = List.generate(
      16,
      (_) => random.nextInt(256),
    ).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    _preferences.setString(_key('installationId'), id);
    return id;
  }

  /// The benchmark result measured by [appVersion], if any.
  double? playoutsPerSecond(String appVersion) =>
      _preferences.getDouble(_key('playoutsPerSecond.$appVersion'));

  Future<void> setPlayoutsPerSecond(String appVersion, double value) =>
      _preferences.setDouble(_key('playoutsPerSecond.$appVersion'), value);
}
