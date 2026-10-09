import 'package:alquran_on_linux/data/content/content_seeder.dart';
import 'package:alquran_on_linux/data/content/seed_bundle.dart';
import 'package:alquran_on_linux/data/content/seed_validator.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/repositories/drift_content_repository.dart';
import 'package:alquran_on_linux/domain/entities/ayah.dart';
import 'package:alquran_on_linux/domain/entities/content_manifest.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Synthetic bundle: 3 surahs x 3 verses. ASCII markers only — structurally
/// valid, obviously not real content.
SeedBundle syntheticBundle() {
  SeedSurah surah(int n) => SeedSurah(
    number: n,
    arabicName: 'سورة $n',
    latinName: 'Surah $n',
    verseCount: 3,
  );
  return SeedBundle(
    surahs: [surah(1), surah(2), surah(3)],
    verses: [
      for (int s = 1; s <= 3; s++)
        for (int a = 1; a <= 3; a++)
          SeedVerse(surah: s, ayah: a, arabic: 'PLACEHOLDER $s:$a'),
    ],
    translations: [
      for (int s = 1; s <= 3; s++)
        for (int a = 1; a <= 3; a++)
          SeedTranslationRow(
            surah: s,
            ayah: a,
            editionId: 'synthetic-id',
            text: 'TRANSLATION $s:$a',
          ),
    ],
    translationEditionId: 'synthetic-id',
  );
}

ContentManifest syntheticManifest() => ContentManifest(
  arabicSource: 'synthetic',
  arabicEdition: 'synthetic-1',
  arabicSha256: 'synthetic',
  translationEditionId: 'synthetic-id',
  translationVersion: 'synthetic-1',
  translationSha256: 'synthetic',
  acquiredAt: DateTime.utc(2026, 10, 9),
  validationReportRef: 'synthetic-report',
);

AppDatabase memoryDb() {
  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  return db;
}

void main() {
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
