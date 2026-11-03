import 'package:flutter/material.dart';

import 'screens/start_screen.dart';
import 'services/app_services.dart';
import 'theme/chibre_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final services = await AppServices.start();
  runApp(ChibreApp(services: services));
}

class ChibreApp extends StatelessWidget {
  const ChibreApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) => Services(
    services: services,
    child: MaterialApp(
      title: 'Chibre',
      debugShowCheckedModeBanner: false,
      theme: chibreTheme(),
      home: const StartScreen(),
    ),
  );
}
