import 'package:drift/drift.dart';

import '../../domain/entities/content_manifest.dart';
import '../database/app_database.dart';
import 'seed_bundle.dart';
import 'seed_validator.dart';

/// Thrown when a bundle fails structural validation. Nothing is written.
class SeedValidationError extends StateError {
  SeedValidationError(this.errors)
    : super('Seed bundle invalid:\n${errors.join('\n')}');

  final List<String> errors;
}

/// Atomically replace the content tables with [bundle] + [manifest].
///
/// Validation runs first; on failure the database is untouched. User-state
/// tables (bookmarks, last read) are never modified by seeding, so content
/// updates cannot endanger user data. Production passes
/// `expectedSurahCount: 114`.
Future<void> seedContent(
  AppDatabase db,
  SeedBundle bundle,
  ContentManifest manifest, {
  int expectedSurahCount = 114,
}) async {
  if (manifest.translationEditionId != bundle.translationEditionId) {
    throw SeedValidationError([
      'Manifest edition ${manifest.translationEditionId} does not match '
          'bundle edition ${bundle.translationEditionId}.',
    ]);
  }
  final List<String> errors = validateSeedBundle(
    bundle,
    expectedSurahCount: expectedSurahCount,
  );
  if (errors.isNotEmpty) {
    throw SeedValidationError(errors);
  }

  await db.transaction(() async {
    await db.delete(db.ayahTranslations).go();
    await db.delete(db.ayahs).go();
    await db.delete(db.surahs).go();
    await db.delete(db.contentMeta).go();

    await db.batch((batch) {
      batch.insertAll(db.surahs, [
        for (final SeedSurah surah in bundle.surahs)
          SurahsCompanion.insert(
            number: Value(surah.number),
            arabicName: surah.arabicName,
            latinName: surah.latinName,
            verseCount: surah.verseCount,
          ),
      ]);
      batch.insertAll(db.ayahs, [
        for (final SeedVerse verse in bundle.verses)
          AyahsCompanion.insert(
            surahNumber: verse.surah,
            ayahNumber: verse.ayah,
            arabicText: verse.arabic,
          ),
      ]);
      batch.insertAll(db.ayahTranslations, [
        for (final SeedTranslationRow row in bundle.translations)
          AyahTranslationsCompanion.insert(
            surahNumber: row.surah,
            ayahNumber: row.ayah,
            editionId: row.editionId,
            translationText: row.text,
          ),
      ]);
      batch.insert(
        db.contentMeta,
        ContentMetaCompanion.insert(
          id: const Value(1),
          arabicSource: manifest.arabicSource,
          arabicEdition: manifest.arabicEdition,
          arabicSha256: manifest.arabicSha256,
          translationEditionId: manifest.translationEditionId,
          translationVersion: manifest.translationVersion,
          translationSha256: manifest.translationSha256,
          acquiredAt: manifest.acquiredAt,
          validationReportRef: manifest.validationReportRef,
        ),
      );
    });
  });
}
