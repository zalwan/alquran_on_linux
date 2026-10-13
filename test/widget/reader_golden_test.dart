import 'dart:convert';
import 'dart:io';

import 'package:alquran_on_linux/core/preferences/settings_providers.dart';
import 'package:alquran_on_linux/core/preferences/shared_preferences_repository.dart';
import 'package:alquran_on_linux/data/content/content_seeder.dart';
import 'package:alquran_on_linux/data/content/tanzil_parser.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/database/database_providers.dart';
import 'package:alquran_on_linux/data/repositories/drift_content_repository.dart';
import 'package:alquran_on_linux/domain/entities/content_manifest.dart';
import 'package:alquran_on_linux/features/reader/reader_page.dart';
import 'package:alquran_on_linux/features/reader/reader_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Visual regression for the real v1.0 reader: Al-Fatihah from the
/// committed Tanzil files, Amiri typeface, ۝ markers, last-read highlight.
/// Review diffs against `spikes/arabic-rendering/REPORT.md` before updating.
void main() {
  testWidgets('real Al-Fatihah renders with markers and highlight', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Load the bundled Amiri face under its real family name: widget tests
    // disable asset fonts, so without this the Arabic renders as tofu and
    // the golden proves nothing. (Sync reads: async file IO hangs inside
    // widget-test bodies in this environment — see bisect notes in git
    // history.)
    final Uint8List amiri = File(
      'assets/fonts/Amiri-Regular.ttf',
    ).readAsBytesSync();
    final FontLoader loader = FontLoader('Amiri')
      ..addFont(Future.value(ByteData.view(amiri.buffer)));
    await loader.load();

    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final AppDatabase database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );
    const String dir = 'data/manifest';
    final ContentManifest manifest = ContentManifest.fromJson(
      jsonDecode(File('$dir/manifest.json').readAsStringSync())
          as Map<String, Object?>,
    );
    await seedContent(
      database,
      parseTanzilBundle(
        File('$dir/tanzil-uthmani-v1.1.txt').readAsStringSync(),
        File('$dir/quran-data-v1.0.xml').readAsStringSync(),
      ),
      manifest,
      expectedSurahCount: 114,
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
        child: const MaterialApp(
          home: Scaffold(body: ReaderPage(surahNumber: 1)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ReaderPage),
      matchesGoldenFile('../goldens/reader_fatihah.png'),
    );
  });
}
