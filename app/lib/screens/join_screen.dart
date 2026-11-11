import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../game/client_game_controller.dart';
import '../services/app_services.dart';
import '../strings.dart';
import '../theme/flow_color.dart';
import '../widgets/open_game_list.dart';
import 'play_screen.dart';

/// Lists the games found on the network; debug builds can also type in an
/// address, as broadcasts don't reach Android emulators.
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  late final _games = Services.of(context).transport.discover();
  final _address = TextEditingController();
  var _joining = false;
  var _measuring = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_measuring) return;
    _measuring = true;
    Services.of(context).measureSpeed();
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _join(OpenGame game) async {
    setState(() => _joining = true);
    final services = Services.of(context);
    final session = services.newClientSession();
    try {
      await session.join(game);
      final advisor = await services.newAdvisor();
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        flowRoute(
          context,
          (_) => PlayScreen(
            controller: ClientGameController(session, advisor: advisor),
          ),
        ),
      );
    } on JoinRejectedException catch (error) {
      _fail(switch (error.reason) {
        JoinRejection.versionMismatch => Strings.versionMismatch,
        JoinRejection.gameFull => Strings.gameFull,
        JoinRejection.unknown => Strings.cannotJoin,
      });
    } catch (_) {
      _fail(Strings.cannotJoin);
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() => _joining = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _joinAddress() {
    final address = _address.text.trim();
    if (address.isEmpty) return;
    _join(
      OpenGame(
        listing: const GameListing(gameId: '', name: '', hostNickname: ''),
        address: address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final installationId = Services.of(context).profile.installationId;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.joinGame)),
      body: _joining
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<OpenGame>>(
                    stream: _games,
                    builder: (context, snapshot) => OpenGameList(
                      games: snapshot.data ?? const [],
                      installationId: installationId,
                      onJoin: _join,
                    ),
                  ),
                ),
                if (kDebugMode)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _address,
                            decoration: const InputDecoration(
                              labelText: Strings.address,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _joinAddress,
                          icon: const Icon(Icons.login),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
