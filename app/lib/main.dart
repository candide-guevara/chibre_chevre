import 'package:flutter/material.dart';

import 'animated_binding.dart';
import 'card_art/card_designs.dart';
import 'screens/start_screen.dart';
import 'services/app_services.dart';
import 'services/test_deal.dart';
import 'theme/chibre_theme.dart';

/// [args] come from the command line on desktop, e.g. `--test-fix-deal=stock`.
Future<void> main(List<String> args) async {
  AnimatedBinding.ensureInitialized();
  final services = await AppServices.start(
    testDeal: TestDeal.fromArgs(args) ?? TestDeal.fromDefine(),
  );
  runApp(ChibreApp(services: services));
}

class ChibreApp extends StatelessWidget {
  const ChibreApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) => Services(
    services: services,
    child: ValueListenableBuilder(
      valueListenable: services.cardDecks,
      builder: (context, design, child) =>
          CardDesignScope(design: design, child: child!),
      child: MaterialApp(
        title: 'Chibre Chèvre',
        debugShowCheckedModeBanner: false,
        theme: chibreTheme(),
        home: const StartScreen(),
      ),
    ),
  );
}
