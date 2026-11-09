import 'package:flutter/material.dart';

import '../card_art/card_design.dart';
import '../card_art/card_designs.dart';
import '../services/app_services.dart';
import '../theme/flow_color.dart';
import '../widgets/card_deck_choice.dart';
import 'host_screen.dart';

/// The nickname, the card design and the game defaults, kept on this phone
/// only.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final _nickname = TextEditingController(
    text: Services.of(context).profile.nickname,
  );

  late CardDesign _design = Services.of(context).cardDecks.value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final design in cardDesigns) {
      Services.of(context).cardDecks.load(design);
    }
  }

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nickname.text.trim().isEmpty) return;
    final services = Services.of(context);
    await services.profile.setNickname(_nickname.text);
    await services.cardDecks.choose(_design);
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
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          Text('Jeu de cartes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          CardDeckChoice(
            selected: _design,
            onChanged: (design) => setState(() => _design = design),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              flowRoute<void>(
                context,
                (_) => const HostScreen(editingDefaults: true),
              ),
            ),
            child: const Text('Paramètres par défaut'),
          ),
        ],
      ),
    ),
  );
}
