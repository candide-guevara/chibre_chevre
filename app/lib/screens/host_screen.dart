import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/advanced_settings.dart';
import '../game/game_defaults.dart';
import '../services/app_services.dart';
import '../game/host_game_controller.dart';
import '../widgets/host_actions_bar.dart';
import 'advanced_settings_screen.dart';
import 'play_screen.dart';
import 'waiting_screen.dart';

/// The options of a new game, starting from the player's game defaults.
/// With [editingDefaults], the same options edit those defaults instead.
class HostScreen extends StatefulWidget {
  const HostScreen({super.key, this.editingDefaults = false, this.solo = false})
    : assert(!(editingDefaults && solo));

  final bool editingDefaults;

  /// A single player game, which starts at once rather than waiting for a
  /// player to join.
  final bool solo;

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  final _name = TextEditingController();
  final _target = TextEditingController();
  var _obenUnde = false;
  var _multipliers = false;
  var _finishLastRound = false;
  var _advanced = const AdvancedSettings();
  var _starting = false;
  var _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    if (!widget.editingDefaults) Services.of(context).measureSpeed();
    _name.text = _defaultName;
    _apply(Services.of(context).profile.gameDefaults);
  }

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  String get _defaultName => widget.solo
      ? 'Partie solo'
      : 'Partie de ${Services.of(context).profile.nickname}';

  void _apply(GameDefaults defaults) {
    _target.text = '${defaults.options.targetScore}';
    _obenUnde = defaults.options.obenUndeAllowed;
    _multipliers = defaults.options.multipliersEnabled;
    _finishLastRound = defaults.options.finishLastRound;
    _advanced = defaults.advanced;
  }

  /// Back to the player's defaults when hosting, or to the app's own when
  /// editing them.
  void _loadDefaults() => setState(() {
    _name.text = _defaultName;
    _apply(
      widget.editingDefaults
          ? const GameDefaults()
          : Services.of(context).profile.gameDefaults,
    );
  });

  GameOptions get _options => GameOptions(
    targetScore: _targetScore!,
    obenUndeAllowed: _obenUnde,
    multipliersEnabled: _multipliers,
    finishLastRound: _finishLastRound,
  );

  Future<void> _saveDefaults() async {
    await Services.of(context).profile
        .setGameDefaults(GameDefaults(options: _options, advanced: _advanced));
    if (mounted) Navigator.of(context).pop();
  }

  void _openAdvanced() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => AdvancedSettingsScreen(
        settings: _advanced,
        onChanged: (settings) => setState(() => _advanced = settings),
      ),
    ),
  );

  int? get _targetScore {
    final value = int.tryParse(_target.text);
    return value != null && value > 0 ? value : null;
  }

  Future<void> _start() async {
    final services = Services.of(context);
    setState(() => _starting = true);
    final session = await services.newHostSession();
    await session.create(
      HostConfig(
        gameName: _name.text.trim().isEmpty ? 'Chibre' : _name.text.trim(),
        nickname: services.profile.nickname!,
        options: _options,
        trickHold: _advanced.trickHold,
        assistance: _advanced.assistance,
        sortByTrump: _advanced.sortByTrump,
        autoAnnounce: _advanced.autoAnnounce,
        thinkingTime: _advanced.thinkingTime,
        solo: widget.solo,
      ),
    );
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => widget.solo
            ? PlayScreen(controller: HostGameController(session))
            : WaitingScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.editingDefaults
            ? 'Paramètres par défaut'
            : widget.solo
            ? 'Jouer seul'
            : 'Créer une partie',
      ),
    ),
    bottomNavigationBar: HostActionsBar(
      onDefaults: _loadDefaults,
      onAdvanced: _openAdvanced,
      primaryLabel: widget.editingDefaults ? 'Enregistrer' : 'Lancer la partie',
      onPrimary: _starting || _targetScore == null
          ? null
          : widget.editingDefaults
          ? _saveDefaults
          : _start,
    ),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // The name is the game's own, not a default; a single player game
        // is never listed, so it needs none.
        if (!widget.editingDefaults && !widget.solo) ...[
          TextField(
            controller: _name,
            maxLength: 30,
            decoration: const InputDecoration(labelText: 'Nom de la partie'),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: _target,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nombre de points'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),
        const Text('Atouts'),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('4 couleurs')),
            ButtonSegment(value: true, label: Text('+ Obenabe, Undenufe')),
          ],
          selected: {_obenUnde},
          onSelectionChanged: (value) =>
              setState(() => _obenUnde = value.single),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Multiplicateurs'),
          subtitle: const Text('♦♥ ×1, ♠♣ ×2, Obenabe et Undenufe ×3'),
          value: _multipliers,
          onChanged: (value) => setState(() => _multipliers = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Finir la dernière manche'),
          subtitle: const Text(
            'L\'équipe qui atteint le score en premier gagne.',
          ),
          value: _finishLastRound,
          onChanged: (value) => setState(() => _finishLastRound = value),
        ),
      ],
    ),
  );
}
