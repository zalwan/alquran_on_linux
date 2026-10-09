import '../entities/ayah.dart';
import '../entities/content_manifest.dart';
import '../entities/surah.dart';

/// Read access to approved Quran content. Implementations return records in
/// source order and never skip, duplicate, or reorder verses.
abstract class QuranContentRepository {
  /// All 114 surahs in canonical order.
  Future<List<Surah>> getSurahs();

  Future<Surah?> getSurah(int surahNumber);

  /// Every verse of [surahNumber] in ascending ayah order.
  Future<List<Ayah>> getAyahs(int surahNumber);

  /// Translation of [key] in [editionId], or null when the edition has no
  /// row for it (callers must not fall back to another edition silently).
  Future<String?> getTranslation(AyahKey key, String editionId);

  Future<ContentManifest> getManifest();
}
