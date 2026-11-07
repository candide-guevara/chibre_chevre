import 'package:flutter/material.dart';

/// Advanced options of a new game. Empty for now.
class AdvancedSettingsScreen extends StatelessWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Paramètres avancés')),
    body: const SizedBox.shrink(),
  );
}
