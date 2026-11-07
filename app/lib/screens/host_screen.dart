import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../game/advanced_settings.dart';
import '../services/app_services.dart';
import '../widgets/host_actions_bar.dart';
import 'advanced_settings_screen.dart';
import 'waiting_screen.dart';

/// The options of a new game.
class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  static const _defaults = GameOptions();

  late final _name = TextEditingController(text: _defaultName);
  final _target = TextEditingController(text: '${_defaults.targetScore}');
  var _obenUnde = _defaults.obenUndeAllowed;
  var _multipliers = _defaults.multipliersEnabled;
  var _advanced = const AdvancedSettings();
  var _starting = false;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  String get _defaultName =>
      'Partie de ${Services.of(context).profile.nickname}';

  void _loadDefaults() => setState(() {
    _name.text = _defaultName;
    _target.text = '${_defaults.targetScore}';
    _obenUnde = _defaults.obenUndeAllowed;
    _multipliers = _defaults.multipliersEnabled;
    _advanced = const AdvancedSettings();
  });

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
        options: GameOptions(
          targetScore: _targetScore!,
          obenUndeAllowed: _obenUnde,
          multipliersEnabled: _multipliers,
        ),
        trickHold: _advanced.trickHold,
        assistance: _advanced.assistance,
        sortByTrump: _advanced.sortByTrump,
      ),
    );
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => WaitingScreen(session: session)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Créer une partie')),
    bottomNavigationBar: HostActionsBar(
      onDefaults: _loadDefaults,
      onAdvanced: _openAdvanced,
      onStart: _starting || _targetScore == null ? null : _start,
    ),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        TextField(
          controller: _name,
          maxLength: 30,
          decoration: const InputDecoration(labelText: 'Nom de la partie'),
        ),
        const SizedBox(height: 16),
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
      ],
    ),
  );
}
