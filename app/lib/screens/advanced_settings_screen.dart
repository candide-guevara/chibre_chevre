import 'package:flutter/material.dart';

import '../game/advanced_settings.dart';
import '../strings.dart';

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
    appBar: AppBar(title: const Text(Strings.advancedSettings)),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(Strings.trickHold(_settings.trickHold)),
        Slider(
          value: _settings.trickHold.inMilliseconds / 1000,
          min: 0.5,
          max: 5,
          divisions: 9,
          label: Strings.seconds(_settings.trickHold),
          onChanged: (value) => _update(
            _settings.copyWith(
              trickHold: Duration(milliseconds: (value * 1000).round()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(Strings.thinkingTime(_settings.thinkingTime)),
        Slider(
          value: _settings.thinkingTime.inMilliseconds / 1000,
          min: 0.2,
          max: 2,
          divisions: 9,
          label: Strings.seconds(_settings.thinkingTime),
          onChanged: (value) => _update(
            _settings.copyWith(
              thinkingTime: Duration(milliseconds: (value * 1000).round()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(Strings.assistance),
          subtitle: const Text(Strings.assistanceDetail),
          value: _settings.assistance,
          onChanged: (value) => _update(_settings.copyWith(assistance: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(Strings.sortByTrump),
          subtitle: const Text(Strings.sortByTrumpOff),
          value: _settings.sortByTrump,
          onChanged: (value) => _update(_settings.copyWith(sortByTrump: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(Strings.autoAnnounce),
          subtitle: const Text(Strings.autoAnnounceDetail),
          value: _settings.autoAnnounce,
          onChanged: (value) =>
              _update(_settings.copyWith(autoAnnounce: value)),
        ),
      ],
    ),
  );
}
