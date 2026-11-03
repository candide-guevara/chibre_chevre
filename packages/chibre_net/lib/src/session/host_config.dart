import 'package:chibre_core/chibre_core.dart';

/// What the host chose on the host game screen.
class HostConfig {
  const HostConfig({
    required this.gameName,
    required this.nickname,
    this.options = const GameOptions(),
  });

  final String gameName;
  final String nickname;
  final GameOptions options;
}
