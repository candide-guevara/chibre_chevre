import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/host_game_controller.dart';
import '../services/app_services.dart';
import '../theme/chibre_theme.dart';
import '../theme/flow_color.dart';
import '../theme/screen_theme.dart';
import '../widgets/pip_button.dart';
import 'host_screen.dart';
import 'join_screen.dart';
import 'play_screen.dart';
import 'profile_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String? _savedGame;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  Future<void> _refresh() async {
    final saved = await HostSession.savedGameName(
      Services.of(context).savedGames,
    );
    if (mounted) setState(() => _savedGame = saved);
  }

  /// Opens [screen] and the screens it leads to with the background [flow].
  Future<void> _open(Widget screen, Color flow) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FlowColor(
          color: flow,
          child: ScreenTheme(color: flow, child: screen),
        ),
      ),
    );
    await _refresh();
  }

  Future<void> _resume() async {
    final session = await Services.of(context).newHostSession();
    await session.resume();
    if (!mounted) return;
    // Paused until the joiner reconnects, unless playing alone.
    await _open(
      PlayScreen(controller: HostGameController(session)),
      ScreenColors.resumed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasProfile = Services.of(context).profile.nickname != null;
    return ScreenTheme(
      color: ScreenColors.start,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  // On one line, smaller on narrow phones.
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Chibre Chèvre',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  // All buttons as wide as the widest one.
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_savedGame != null) ...[
                          PipButton(
                            suit: Suit.diamonds,
                            onPressed: hasProfile ? _resume : null,
                            child: Text(
                              'Reprendre « $_savedGame »',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        PipButton(
                          suit: Suit.spades,
                          onPressed: hasProfile
                              ? () => _open(
                                  const JoinScreen(),
                                  ScreenColors.network,
                                )
                              : null,
                          child: const Text('Rejoindre une partie'),
                        ),
                        const SizedBox(height: 16),
                        PipButton(
                          suit: Suit.hearts,
                          onPressed: hasProfile
                              ? () => _open(
                                  const HostScreen(),
                                  ScreenColors.network,
                                )
                              : null,
                          child: const Text('Créer une partie'),
                        ),
                        const SizedBox(height: 16),
                        PipButton(
                          suit: Suit.clubs,
                          onPressed: hasProfile
                              ? () => _open(
                                  const HostScreen(solo: true),
                                  ScreenColors.solo,
                                )
                              : null,
                          child: const Text('Jouer seul'),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => _open(
                            const ProfileScreen(),
                            ScreenColors.profile,
                          ),
                          child: const Text('Profil'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
