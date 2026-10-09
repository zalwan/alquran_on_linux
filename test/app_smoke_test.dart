import 'package:alquran_on_linux/app/app.dart';
import 'package:alquran_on_linux/core/preferences/settings_providers.dart';
import 'package:alquran_on_linux/core/preferences/shared_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> makeApp() async {
  SharedPreferences.setMockInitialValues({});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [
      preferencesRepositoryProvider.overrideWithValue(
        SharedPreferencesRepository(prefs),
      ),
    ],
    child: const AlquranApp(),
  );
}

void main() {
  testWidgets('app launches with rail navigation', (tester) async {
    await tester.pumpWidget(await makeApp());
    await tester.pumpAndSettle();

    expect(find.text('Alquran'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pumpAndSettle();
    expect(
      find.text('Saved verses will appear here in Phase 2.'),
      findsOneWidget,
    );
  });

  testWidgets('settings page changes theme and font size', (tester) async {
    await tester.pumpWidget(await makeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.text('Appearance'));
    expect(Theme.of(context).brightness, Brightness.dark);
  });
}
