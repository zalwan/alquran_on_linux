import 'package:alquran_on_linux/data/content/content_seeder.dart';
import 'seed_fixtures.dart';
import 'dart:io';
import 'package:alquran_on_linux/data/content/seed_bundle.dart';
import 'package:alquran_on_linux/data/content/seed_validator.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/repositories/drift_content_repository.dart';
import 'package:alquran_on_linux/data/repositories/drift_user_state.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:alquran_on_linux/domain/entities/ayah.dart';
import 'package:alquran_on_linux/domain/entities/content_manifest.dart';
import 'package:alquran_on_linux/domain/entities/surah.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  arabicOnlyTests();
  migrationTests();
  schemaMigrationTests();

  group('seed validator', () {
    test('accepts a consistent bundle', () {
      expect(
        validateSeedBundle(syntheticBundle(), expectedSurahCount: 3),
        isEmpty,
      );
    });

    test('rejects wrong surah count', () {
      expect(
        validateSeedBundle(syntheticBundle(), expectedSurahCount: 114),
        isNotEmpty,
      );
    });

    test('detects gaps, duplicates, orphans, and edition drift', () {
      final SeedBundle base = syntheticBundle();

      final missingVerse = SeedBundle(
        surahs: base.surahs,
        verses: base.verses
            .where((v) => !(v.surah == 2 && v.ayah == 2))
            .toList(),
        translations: base.translations,
        translationEditionId: base.translationEditionId,
      );
      expect(
        validateSeedBundle(missingVerse, expectedSurahCount: 3),
        anyElement(contains('Surah 2')),
      );

      final duplicated = SeedBundle(
        surahs: base.surahs,
        verses: [...base.verses, base.verses.first],
        translations: base.translations,
        translationEditionId: base.translationEditionId,
      );
      expect(
        validateSeedBundle(duplicated, expectedSurahCount: 3),
        anyElement(contains('Duplicate verse')),
      );

      final orphan = SeedBundle(
        surahs: base.surahs,
        verses: base.verses,
        translations: [
          ...base.translations,
          const SeedTranslationRow(
            surah: 3,
            ayah: 99,
            editionId: 'synthetic-id',
            text: 'ORPHAN',
          ),
        ],
        translationEditionId: base.translationEditionId,
      );
      expect(
        validateSeedBundle(orphan, expectedSurahCount: 3),
        anyElement(contains('Orphan')),
      );

      final wrongEdition = SeedBundle(
        surahs: base.surahs,
        verses: base.verses,
        translations: base.translations,
        translationEditionId: 'other-id',
      );
      expect(
        validateSeedBundle(wrongEdition, expectedSurahCount: 3),
        anyElement(contains('unexpected edition')),
      );
    });
  });

  group('seeder + drift repository', () {
    test('seeds atomically and serves ordered content', () async {
      final AppDatabase db = memoryDb();
      final repo = DriftQuranContentRepository(db);

      await expectLater(
        repo.getManifest(),
        throwsStateError,
        reason: 'unseeded database must fail loudly',
      );

      await seedContent(
        db,
        syntheticBundle(),
        syntheticManifest(),
        expectedSurahCount: 3,
      );

      final surahs = await repo.getSurahs();
      expect(surahs.map((s) => s.number), [1, 2, 3]);

      final verses = await repo.getAyahs(2);
      expect(verses.map((v) => v.key.ayahNumber), [1, 2, 3]);
      expect(
        await repo.getTranslation(
          const AyahKey(surahNumber: 2, ayahNumber: 2),
          'synthetic-id',
        ),
        'TRANSLATION 2:2',
      );
      expect(
        await repo.getTranslation(
          const AyahKey(surahNumber: 2, ayahNumber: 2),
          'unknown-edition',
        ),
        isNull,
        reason: 'no silent fallback to another edition',
      );

      final manifest = await repo.getManifest();
      expect(manifest.translationEditionId, 'synthetic-id');
      expect(manifest.arabicSha256, 'synthetic');
    });

    test('invalid bundle writes nothing', () async {
      final AppDatabase db = memoryDb();
      final repo = DriftQuranContentRepository(db);

      final SeedBundle bad = syntheticBundle();
      final SeedBundle broken = SeedBundle(
        surahs: bad.surahs,
        verses: [],
        translations: bad.translations,
        translationEditionId: bad.translationEditionId,
      );

      await expectLater(
        seedContent(db, broken, syntheticManifest(), expectedSurahCount: 3),
        throwsA(isA<SeedValidationError>()),
      );
      expect(await repo.getSurahs(), isEmpty);
      await expectLater(repo.getManifest(), throwsStateError);
    });

    test('manifest/bundle edition mismatch is rejected', () async {
      final AppDatabase db = memoryDb();
      await expectLater(
        seedContent(
          db,
          syntheticBundle(),
          ContentManifest(
            arabicSource: 's',
            arabicEdition: 'e',
            arabicSha256: 'h',
            translationEditionId: 'different-id',
            translationVersion: 'v',
            translationSha256: 'h',
            acquiredAt: DateTime.utc(2026, 10, 9),
            validationReportRef: 'r',
          ),
          expectedSurahCount: 3,
        ),
        throwsA(isA<SeedValidationError>()),
      );
    });
  });
}

void arabicOnlyTests() {
  group('arabic-only datasets (v1.0)', () {
    test('validator accepts a bundle without translations', () {
      expect(
        validateSeedBundle(
          syntheticBundle(withTranslation: false),
          expectedSurahCount: 3,
        ),
        isEmpty,
      );
    });

    test('manifest requires the translation trio all-or-nothing', () {
      expect(syntheticManifest(withTranslation: false).hasTranslation, isFalse);
      expect(
        () => ContentManifest(
          arabicSource: 's',
          arabicEdition: 'e',
          arabicSha256: 'h',
          translationEditionId: 'only-edition',
          acquiredAt: DateTime.utc(2026, 10, 9),
          validationReportRef: 'r',
        ),
        throwsArgumentError,
      );
    });

    test('edition id without rows is rejected', () {
      final SeedBundle base = syntheticBundle(withTranslation: false);
      final SeedBundle bad = SeedBundle(
        surahs: base.surahs,
        verses: base.verses,
        translations: const [],
        translationEditionId: 'ghost-id',
      );
      expect(
        validateSeedBundle(bad, expectedSurahCount: 3),
        anyElement(contains('no translation rows')),
      );
    });

    test('arabic-only seed serves verses with null translations', () async {
      final AppDatabase db = memoryDb();
      final repo = DriftQuranContentRepository(db);

      await seedContent(
        db,
        syntheticBundle(withTranslation: false),
        syntheticManifest(withTranslation: false),
        expectedSurahCount: 3,
      );

      final verses = await repo.getAyahs(1);
      expect(verses.map((v) => v.key.ayahNumber), [1, 2, 3]);
      expect(
        await repo.getTranslation(
          const AyahKey(surahNumber: 1, ayahNumber: 1),
          'any-edition',
        ),
        isNull,
      );
      final manifest = await repo.getManifest();
      expect(manifest.hasTranslation, isFalse);
      expect(manifest.translationEditionId, isNull);
    });
  });
}

void migrationTests() {
  group('legacy and corrupt databases', () {
    test('rows written by raw SQL stay readable after reopen', () async {
      final Directory dir = await Directory.systemTemp.createTemp(
        'alquran-legacy',
      );
      addTearDown(() => dir.delete(recursive: true));
      final File file = File('${dir.path}/alquran.db');

      // Drift creates the schema on first open; simulate rows written by
      // an older app version (or any external writer) with raw SQL.
      final AppDatabase setup = AppDatabase(file);
      await setup.customStatement("INSERT INTO bookmarks VALUES (2, 255, 0)");
      await setup.customStatement(
        "INSERT INTO reading_positions VALUES (1, 2, 255, 0)",
      );
      await setup.close();

      // New code opens the same file: user state must survive untouched.
      final AppDatabase reopened = AppDatabase(file);
      addTearDown(reopened.close);
      expect(
        await DriftBookmarkRepository(
          reopened,
        ).isBookmarked(const AyahKey(surahNumber: 2, ayahNumber: 255)),
        isTrue,
      );
      expect(
        (await DriftReadingProgressRepository(reopened).loadLastRead())?.key,
        const AyahKey(surahNumber: 2, ayahNumber: 255),
      );
    });

    test('corrupt database file fails loudly, never silently', () async {
      final Directory dir = await Directory.systemTemp.createTemp(
        'alquran-corrupt',
      );
      addTearDown(() => dir.delete(recursive: true));
      final File file = File('${dir.path}/alquran.db');
      await file.writeAsBytes([0, 1, 2, 3, 4, 5, 6, 7]);

      final AppDatabase broken = AppDatabase(file);
      addTearDown(broken.close);
      // Reads throw instead of returning invented data; the UI layers turn
      // these into their pending/error states (covered by widget tests).
      await expectLater(
        DriftBookmarkRepository(broken).listBookmarks(),
        throwsA(anything),
      );
      await expectLater(
        DriftReadingProgressRepository(broken).loadLastRead(),
        throwsA(anything),
      );
    });
  });
}

void schemaMigrationTests() {
  group('schema migration v1 -> v2', () {
    test('adds revelation_type without losing rows', () async {
      final Directory dir = await Directory.systemTemp.createTemp(
        'alquran-migrate',
      );
      addTearDown(() => dir.delete(recursive: true));
      final File file = File('${dir.path}/alquran.db');

      // Hand-built v1 database: surahs WITHOUT revelation_type, plus a
      // user bookmark. user_version = 1 marks it as a v1 install.
      final raw = sqlite3.open(file.path);
      raw.execute(
        'CREATE TABLE surahs (number INTEGER NOT NULL PRIMARY KEY, '
        'arabic_name TEXT NOT NULL, latin_name TEXT NOT NULL, '
        'verse_count INTEGER NOT NULL)',
      );
      raw.execute("INSERT INTO surahs VALUES (1, 'AR', 'Surah 1', 7)");
      raw.execute(
        'CREATE TABLE bookmarks (surah_number INTEGER NOT NULL, '
        'ayah_number INTEGER NOT NULL, created_at INTEGER NOT NULL, '
        'PRIMARY KEY (surah_number, ayah_number))',
      );
      raw.execute('INSERT INTO bookmarks VALUES (1, 2, 0)');
      raw.execute('PRAGMA user_version = 1');
      raw.close();

      final AppDatabase upgraded = AppDatabase(file);
      addTearDown(upgraded.close);
      expect(upgraded.schemaVersion, 2);

      final repo = DriftQuranContentRepository(upgraded);
      final Surah? surah = await repo.getSurah(1);
      expect(surah, isNotNull);
      expect(surah!.revelationType, isNull);
      expect(
        await DriftBookmarkRepository(
          upgraded,
        ).isBookmarked(const AyahKey(surahNumber: 1, ayahNumber: 2)),
        isTrue,
      );
    });
  });
}
