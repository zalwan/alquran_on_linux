import 'package:drift/drift.dart';

import '../../domain/entities/ayah.dart';
import '../../domain/entities/content_manifest.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../database/app_database.dart';

/// Production [QuranContentRepository] over the seeded content tables.
/// Wired behind [quranContentProvider] once the approved dataset is seeded;
/// throws [StateError] while the database holds no content (the UI shows
/// [ContentUnavailable] in that case).
class DriftQuranContentRepository implements QuranContentRepository {
  DriftQuranContentRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Surah>> getSurahs() async {
    final rows = await (_db.select(
      _db.surahs,
    )..orderBy([(t) => OrderingTerm.asc(t.number)])).get();
    return [
      for (final SurahRow row in rows)
        Surah(
          number: row.number,
          arabicName: row.arabicName,
          latinName: row.latinName,
          verseCount: row.verseCount,
        ),
    ];
  }

  @override
  Future<Surah?> getSurah(int surahNumber) async {
    final SurahRow? row = await (_db.select(
      _db.surahs,
    )..where((t) => t.number.equals(surahNumber))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    return Surah(
      number: row.number,
      arabicName: row.arabicName,
      latinName: row.latinName,
      verseCount: row.verseCount,
    );
  }

  @override
  Future<List<Ayah>> getAyahs(int surahNumber) async {
    final rows =
        await (_db.select(_db.ayahs)
              ..where((t) => t.surahNumber.equals(surahNumber))
              ..orderBy([(t) => OrderingTerm.asc(t.ayahNumber)]))
            .get();
    return [
      for (final AyahRow row in rows)
        Ayah(
          key: AyahKey(
            surahNumber: row.surahNumber,
            ayahNumber: row.ayahNumber,
          ),
          arabicText: row.arabicText,
        ),
    ];
  }

  @override
  Future<String?> getTranslation(AyahKey key, String editionId) async {
    final AyahTranslationRow? row =
        await (_db.select(_db.ayahTranslations)..where(
              (t) =>
                  t.surahNumber.equals(key.surahNumber) &
                  t.ayahNumber.equals(key.ayahNumber) &
                  t.editionId.equals(editionId),
            ))
            .getSingleOrNull();
    return row?.translationText;
  }

  @override
  Future<ContentManifest> getManifest() async {
    final ContentMetaData? row = await (_db.select(
      _db.contentMeta,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) {
      throw StateError('No content seeded yet.');
    }
    return ContentManifest(
      arabicSource: row.arabicSource,
      arabicEdition: row.arabicEdition,
      arabicSha256: row.arabicSha256,
      translationEditionId: row.translationEditionId,
      translationVersion: row.translationVersion,
      translationSha256: row.translationSha256,
      acquiredAt: row.acquiredAt,
      validationReportRef: row.validationReportRef,
    );
  }
}
