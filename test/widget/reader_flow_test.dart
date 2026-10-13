import 'package:alquran_on_linux/app/app.dart';
import 'package:alquran_on_linux/core/preferences/settings_providers.dart';
import 'package:alquran_on_linux/core/preferences/shared_preferences_repository.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/database/database_providers.dart';
import 'package:alquran_on_linux/features/reader/reader_page.dart';
import 'package:alquran_on_linux/features/reader/reader_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../unit/fakes.dart';
import '../test_helpers.dart';

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
  readerWaveATests();
  readerWaveBTests();
  readerKeyboardTests();
  testWidgets('index lists surahs and opens the reader', (tester) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    expect(find.text('Surah 1'), findsOneWidget);
    expect(find.text('Surah 3'), findsOneWidget);

    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    // Four verse cards with placeholder text and translations.
    expect(
      find.text('PLACEHOLDER 2:1 \u06DD١', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text('PLACEHOLDER 2:4 \u06DD٤', findRichText: true),
      findsOneWidget,
    );
    expect(find.textContaining('TRANSLATION'), findsNWidgets(4));
  });

  testWidgets('opening a surah records last-read and highlights it', (
    tester,
  ) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    // Home offers to continue at the recorded position.
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Surah 2, Ayah 1'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue reading'));
    await tester.pumpAndSettle();
    expect(
      find.text('PLACEHOLDER 2:1 \u06DD١', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('bookmark toggle round-trips to the bookmarks page', (
    tester,
  ) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
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

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    expect(find.text('Quran content is not available yet'), findsOneWidget);
    expect(
      find.textContaining('Bookmarks, theme, and settings keep working'),
      findsOneWidget,
    );
  });
}

void readerWaveATests() {
  testWidgets('reader shows header, markers, and footer navigation', (
    tester,
  ) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    // Header with Latin name and verse count.
    expect(find.text('Surah 2 · 4 verses'), findsOneWidget);
    // Traditional end-of-verse marker inside the verse text.
    expect(
      find.text('PLACEHOLDER 2:1 \u06DD١', findRichText: true),
      findsOneWidget,
    );
    // Prev/next footer.
    expect(find.text('‹ Surah 1'), findsOneWidget);
    expect(find.text('Surah 3 ›'), findsOneWidget);

    await tester.tap(find.text('Surah 3 ›'));
    await tester.pumpAndSettle();
    expect(
      find.text('PLACEHOLDER 3:1 \u06DD١', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('jump-to-ayah moves and records last-read', (tester) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '3');
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Surah 2, Ayah 3'), findsOneWidget);
  });

  testWidgets('invalid jump shows an inline error', (tester) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '99');
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a number between 1 and 4.'), findsOneWidget);
  });
}

void readerWaveBTests() {
  testWidgets('home dashboard shows shortcuts and live bookmark count', (
    tester,
  ) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    expect(find.text('Calm offline reading'), findsOneWidget);
    expect(find.text('Browse the surah index'), findsOneWidget);
    expect(find.text('No saved verses yet'), findsOneWidget);

    // Bookmark a verse, return home, see the count update.
    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Bookmark this verse').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.text('1 saved verse'), findsOneWidget);

    await tester.tap(find.text('Browse the surah index'));
    await tester.pumpAndSettle();
    expect(find.text('Surah 3'), findsOneWidget);
  });

  testWidgets('tapping a bookmark opens its verse', (tester) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '3');
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    // Bookmark verse 3, then open the bookmarks page.
    await tester.tap(find.byKey(const ValueKey('bookmark-2-3')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.byIcon(Icons.bookmark_border),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Surah 2, Ayah 3'), findsOneWidget);

    // Tapping the entry reveals verse 3 in the reader.
    await tester.tap(find.text('Surah 2, Ayah 3'));
    await tester.pumpAndSettle();
    expect(
      find.text('PLACEHOLDER 2:3 \u06DD٣', findRichText: true),
      findsOneWidget,
    );
  });
}

void readerKeyboardTests() {
  testWidgets('arrow keys move the reading position', (tester) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.home_outlined);
    await tester.pumpAndSettle();
    expect(find.text('Surah 2, Ayah 3'), findsOneWidget);
  });

  testWidgets('J/K move, Home/End jump to edges', (tester) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.home_outlined);
    await tester.pumpAndSettle();
    expect(find.text('Surah 2, Ayah 4'), findsOneWidget);
  });

  testWidgets('/ focuses the jump field, Esc returns to the index', (
    tester,
  ) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.slash);
    await tester.pumpAndSettle();
    expect(FocusManager.instance.primaryFocus?.debugLabel, 'jump-field');

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Surah 1'), findsOneWidget);
  });

  testWidgets('verse cards expose position semantics', (tester) async {
    await tester.pumpWidget(await makeFlowApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah 2'));
    await tester.pumpAndSettle();

    final SemanticsHandle handle = tester.ensureSemantics();
    expect(
      find.bySemanticsLabel(RegExp('Ayah 1 of 4.*current position')),
      findsOneWidget,
    );
    handle.dispose();
  });
}
