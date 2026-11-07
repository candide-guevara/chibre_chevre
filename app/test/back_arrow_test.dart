import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre/widgets/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pushed screens show the drawn back arrow', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: chibreTheme(),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    Scaffold(appBar: AppBar(title: const Text('Profil'))),
              ),
            ),
            child: const Text('Ouvrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Ouvrir'));
    await tester.pumpAndSettle();

    expect(find.byType(BackArrow), findsOneWidget);
  });
}
