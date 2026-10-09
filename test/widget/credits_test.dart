import 'package:alquran_on_linux/app/app.dart';
import 'package:alquran_on_linux/core/preferences/settings_providers.dart';
import 'package:alquran_on_linux/core/preferences/shared_preferences_repository.dart';
import 'package:alquran_on_linux/data/content/content_seeder.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/database/database_providers.dart';
import 'package:alquran_on_linux/data/repositories/drift_content_repository.dart';
import 'package:alquran_on_linux/features/reader/reader_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../unit/fakes.dart';
import '../unit/seed_fixtures.dart';

Future<Widget> makeCreditsApp({bool withContent = false}) async {
  SharedPreferences.setMockInitialValues({});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final AppDatabase database = AppDatabase.forTesting(NativeDatabase.memory());
  return ProviderScope(
    overrides: [
      preferencesRepositoryProvider.overrideWithValue(
        SharedPreferencesRepository(prefs),
      ),
      appDatabaseProvider.overrideWithValue(database),
      if (withContent)
        quranContentProvider.overrideWithValue(FakeQuranContentRepository()),
    ],
    child: const AlquranApp(),
  );
}

void main() {
  arabicOnlyCreditsTests();
  testWidgets('about page shows pending state while gate is closed', (
    tester,
  ) async {
    await tester.pumpWidget(await makeCreditsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.info_outlined));
    await tester.pumpAndSettle();

    expect(find.text('About & Sources'), findsOneWidget);
    expect(find.textContaining('No approved content bundle'), findsOneWidget);
    expect(find.textContaining('Tanzil Project'), findsOneWidget);
    expect(
      find.text('Indonesian translation — QuranEnc (quranenc.com)'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.textContaining('ships no QF content'),
      300,
    );
    expect(find.textContaining('ships no QF content'), findsOneWidget);
  });

  testWidgets('about page shows manifest fields when content is seeded', (
    tester,
  ) async {
    await tester.pumpWidget(await makeCreditsApp(withContent: true));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.info_outlined));
    await tester.pumpAndSettle();

    expect(find.textContaining('fake-id'), findsOneWidget);
    expect(find.textContaining('fake-report'), findsOneWidget);
    expect(find.textContaining('No approved content bundle'), findsNothing);
  });
}

void arabicOnlyCreditsTests() {
  testWidgets('about page marks an arabic-only manifest honestly', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final AppDatabase database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );
    await seedContent(
      database,
      syntheticBundle(withTranslation: false),
      syntheticManifest(withTranslation: false),
      expectedSurahCount: 3,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesRepositoryProvider.overrideWithValue(
            SharedPreferencesRepository(prefs),
          ),
          appDatabaseProvider.overrideWithValue(database),
          quranContentProvider.overrideWithValue(
            DriftQuranContentRepository(database),
          ),
        ],
        child: const AlquranApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.info_outlined));
    await tester.pumpAndSettle();

    expect(find.textContaining('synthetic-1'), findsOneWidget);
    expect(find.textContaining('Arabic-only dataset'), findsOneWidget);
    expect(find.textContaining('No approved content bundle'), findsNothing);
  });
}
