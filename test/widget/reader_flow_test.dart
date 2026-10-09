import 'package:alquran_on_linux/app/app.dart';
import 'package:alquran_on_linux/core/preferences/settings_providers.dart';
import 'package:alquran_on_linux/core/preferences/shared_preferences_repository.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/database/database_providers.dart';
import 'package:alquran_on_linux/features/reader/reader_page.dart';
import 'package:alquran_on_linux/features/reader/reader_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../unit/fakes.dart';

Future<Widget> makeFlowApp() async {
  SharedPreferences.setMockInitialValues({});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final AppDatabase database = AppDatabase.forTesting(NativeDatabase.memory());
  return ProviderScope(
    overrides: [
      preferencesRepositoryProvider.overrideWithValue(
        SharedPreferencesRepository(prefs),
      ),
      appDatabaseProvider.overrideWithValue(database),
      quranContentProvider.overrideWithValue(FakeQuranContentRepository()),
    ],
    child: const AlquranApp(),
  );
}

void main() {
  testWidgets('index lists surahs and opens the reader', (tester) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.library_books_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Surah 1'), findsOneWidget);
    expect(find.text('Surah 3'), findsOneWidget);

    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    // Four verse cards with placeholder text and translations.
    expect(find.text('PLACEHOLDER 2:1'), findsOneWidget);
    expect(find.text('PLACEHOLDER 2:4'), findsOneWidget);
    expect(find.textContaining('TRANSLATION'), findsNWidgets(4));
  });

  testWidgets('opening a surah records last-read and highlights it', (
    tester,
  ) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.library_books_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    // Home offers to continue at the recorded position.
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Continue reading: Surah 2, Ayah 1'), findsOneWidget);

    await tester.tap(find.text('Continue reading'));
    await tester.pumpAndSettle();
    expect(find.text('PLACEHOLDER 2:1'), findsOneWidget);
  });

  testWidgets('bookmark toggle round-trips to the bookmarks page', (
    tester,
  ) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.library_books_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 1'));
    await tester.pumpAndSettle();

    // Tooltips disambiguate verse-card buttons from the rail icon.
    await tester.tap(find.byTooltip('Bookmark this verse').first);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.byIcon(Icons.bookmark_border),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Surah 1, Ayah 1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.textContaining('No bookmarks yet'), findsOneWidget);
  });

  testWidgets('invalid surah number shows an error, not a crash', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final AppDatabase database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesRepositoryProvider.overrideWithValue(
            SharedPreferencesRepository(prefs),
          ),
          appDatabaseProvider.overrideWithValue(database),
          quranContentProvider.overrideWithValue(FakeQuranContentRepository()),
        ],
        child: const MaterialApp(home: ReaderPage(surahNumber: 999)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Quran content is not available yet'), findsOneWidget);
  });

  testWidgets('index without content override explains the gate', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final AppDatabase database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesRepositoryProvider.overrideWithValue(
            SharedPreferencesRepository(prefs),
          ),
          appDatabaseProvider.overrideWithValue(database),
          // No quranContentProvider override: the gate is closed.
        ],
        child: const AlquranApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.library_books_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Quran content is not available yet'), findsOneWidget);
    expect(
      find.textContaining('Bookmarks, theme, and settings keep working'),
      findsOneWidget,
    );
  });
}
