import 'package:flutter/material.dart';

import '../services/app_services.dart';
import 'host_screen.dart';

/// The nickname and the game defaults, kept on this phone only.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final _nickname = TextEditingController(
    text: Services.of(context).profile.nickname,
  );

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nickname.text.trim().isEmpty) return;
    await Services.of(context).profile.setNickname(_nickname.text);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profil')),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: ValueListenableBuilder(
          valueListenable: _nickname,
          builder: (context, value, _) => FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: value.text.trim().isEmpty ? null : _save,
            child: const Text('Enregistrer'),
          ),
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            controller: _nickname,
            autofocus: true,
            maxLength: 20,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Pseudo'),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const HostScreen(editingDefaults: true),
              ),
            ),
            child: const Text('Paramètres par défaut'),
          ),
        ],
      ),
    ),
  );
}
