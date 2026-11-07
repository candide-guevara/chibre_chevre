import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';

import '../services/app_services.dart';
import 'waiting_screen.dart';

/// The options of a new game.
class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  late final _name = TextEditingController(
    text: 'Partie de ${Services.of(context).profile.nickname}',
  );
  final _target = TextEditingController(text: '1000');
  var _obenUnde = false;
  var _multipliers = false;
  var _trickHold = HostConfig.defaultTrickHold;
  var _starting = false;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

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
        trickHold: _trickHold,
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
        const SizedBox(height: 16),
        Text('Pause avant de ramasser un pli : ${_seconds(_trickHold)}'),
        Slider(
          value: _trickHold.inMilliseconds / 1000,
          min: 0.5,
          max: 5,
          divisions: 9,
          label: _seconds(_trickHold),
          onChanged: (value) => setState(
            () => _trickHold = Duration(milliseconds: (value * 1000).round()),
          ),
        ),
        const Text(
          'Plus longue pour laisser aux débutants le temps de retenir '
          'les cartes jouées.',
        ),
        const SizedBox(height: 32),
        Center(
          child: FilledButton(
            onPressed: _starting || _targetScore == null ? null : _start,
            child: const Text('Lancer la partie'),
          ),
        ),
      ],
    ),
  );
}

/// "1,5 s": French decimal comma.
String _seconds(Duration duration) =>
    '${(duration.inMilliseconds / 1000).toStringAsFixed(1).replaceAll('.', ',')} s';
