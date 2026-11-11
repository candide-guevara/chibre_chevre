import '../theme/flow_color.dart';

import 'dart:async';

import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../game/host_game_controller.dart';
import '../strings.dart';
import 'play_screen.dart';

/// The host waits for a player to join.
class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key, required this.session});

  final HostSession session;

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  late final StreamSubscription<TableView> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.session.tables
        .where((table) => table.phase != TablePhase.waitingForPlayer)
        .listen((_) => _play());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _play() {
    _subscription.cancel();
    Navigator.of(context).pushReplacement(
      flowRoute(
        context,
        (_) => PlayScreen(controller: HostGameController(widget.session)),
      ),
    );
  }

  Future<void> _cancel() async {
    await widget.session.close();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _cancel();
    },
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              Strings.waitingForPlayer,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (kDebugMode && widget.session.address != null) ...[
              const SizedBox(height: 8),
              Text(Strings.addressIs(widget.session.address!)),
            ],
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: _cancel,
              child: const Text(Strings.cancel),
            ),
          ],
        ),
      ),
    ),
  );
}
