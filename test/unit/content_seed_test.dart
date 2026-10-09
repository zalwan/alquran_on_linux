import 'package:alquran_on_linux/data/content/content_seeder.dart';
import 'seed_fixtures.dart';
import 'package:alquran_on_linux/data/content/seed_bundle.dart';
import 'package:alquran_on_linux/data/content/seed_validator.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/repositories/drift_content_repository.dart';
import 'package:alquran_on_linux/domain/entities/ayah.dart';
import 'package:alquran_on_linux/domain/entities/content_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  arabicOnlyTests();

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
