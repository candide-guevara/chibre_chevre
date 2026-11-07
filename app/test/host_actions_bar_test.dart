import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre/widgets/host_actions_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<String>> pumpBar(
  WidgetTester tester, {
  bool canStart = true,
}) async {
  final taps = <String>[];
  tester.view.physicalSize = const Size(412, 906);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: chibreTheme(),
      home: Scaffold(
        bottomNavigationBar: HostActionsBar(
          onDefaults: () => taps.add('defaults'),
          onAdvanced: () => taps.add('advanced'),
          primaryLabel: 'Lancer la partie',
          onPrimary: canStart ? () => taps.add('start') : null,
        ),
      ),
    ),
  );
  return taps;
}

void main() {
  testWidgets('each button calls its action', (tester) async {
    final taps = await pumpBar(tester);
    await tester.tap(find.text('Par défaut'));
    await tester.tap(find.text('Avancé'));
    await tester.tap(find.text('Lancer la partie'));
    expect(taps, ['defaults', 'advanced', 'start']);
  });

  testWidgets('starting can be disabled', (tester) async {
    final taps = await pumpBar(tester, canStart: false);
    await tester.tap(find.text('Lancer la partie'));
    expect(taps, isEmpty);
  });
}
