import 'dart:io';

import 'package:alquran_on_linux/app/app.dart';
import 'package:alquran_on_linux/core/preferences/settings_providers.dart';
import 'package:alquran_on_linux/core/preferences/shared_preferences_repository.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/database/database_providers.dart';
import 'package:alquran_on_linux/features/reader/reader_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_helpers.dart';
import '../unit/fakes.dart';

/// Visual regression for the modern shell: extended rail, home hero, rich
/// index rows. Latin UI renders as blocks (test font); Arabic uses the
/// bundled Amiri face loaded below. Review diffs before updating.
Future<Widget> makeVisualApp() async {
  final Uint8List amiri = File(
    'assets/fonts/Amiri-Regular.ttf',
  ).readAsBytesSync();
  final FontLoader loader = FontLoader('Amiri')
    ..addFont(Future.value(ByteData.view(amiri.buffer)));
  await loader.load();

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
  testWidgets('home hero and stats', (tester) async {
    tester.view.physicalSize = const Size(1100, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(await makeVisualApp());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../goldens/home_dashboard.png'),
    );
  });

  testWidgets('surah index with badges', (tester) async {
    tester.view.physicalSize = const Size(1100, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(await makeVisualApp());
    await tester.pumpAndSettle();

    await tapRail(tester, Icons.library_books_outlined);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../goldens/surah_index.png'),
    );
  });
}
