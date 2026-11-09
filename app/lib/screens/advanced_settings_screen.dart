import 'package:flutter/material.dart';

import '../game/advanced_settings.dart';

/// Advanced options of a new game, reported through [onChanged].
class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final AdvancedSettings settings;
  final ValueChanged<AdvancedSettings> onChanged;

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  late var _settings = widget.settings;

  void _update(AdvancedSettings settings) {
    setState(() => _settings = settings);
    widget.onChanged(settings);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Paramètres avancés')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Pause avant de ramasser un pli : ${_seconds(_settings.trickHold)}',
        ),
        Slider(
          value: _settings.trickHold.inMilliseconds / 1000,
          min: 0.5,
          max: 5,
          divisions: 9,
          label: _seconds(_settings.trickHold),
          onChanged: (value) => _update(
            _settings.copyWith(
              trickHold: Duration(milliseconds: (value * 1000).round()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Réflexion des ordinateurs : ${_seconds(_settings.thinkingTime)}',
        ),
        Slider(
          value: _settings.thinkingTime.inMilliseconds / 1000,
          min: 0.2,
          max: 2,
          divisions: 9,
          label: _seconds(_settings.thinkingTime),
          onChanged: (value) => _update(
            _settings.copyWith(
              thinkingTime: Duration(milliseconds: (value * 1000).round()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Aide de jeu'),
          subtitle: const Text(
            'Boutons « Jouer pour moi » et « Cartes jouées »',
          ),
          value: _settings.assistance,
          onChanged: (value) => _update(_settings.copyWith(assistance: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Trier la main selon l\'atout'),
          subtitle: const Text('Sinon : ♥ ♠ ♦ ♣, du 6 à l\'as'),
          value: _settings.sortByTrump,
          onChanged: (value) => _update(_settings.copyWith(sortByTrump: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Annonces automatiques'),
          subtitle: const Text(
            'Stöck annoncé tout seul, annonces proposées en début de manche',
          ),
          value: _settings.autoAnnounce,
          onChanged: (value) =>
              _update(_settings.copyWith(autoAnnounce: value)),
        ),
      ],
    ),
  );
}

/// "1,5 s": French decimal comma.
String _seconds(Duration duration) =>
    '${(duration.inMilliseconds / 1000).toStringAsFixed(1).replaceAll('.', ',')} s';
