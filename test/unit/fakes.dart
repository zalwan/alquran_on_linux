import 'package:alquran_on_linux/domain/entities/ayah.dart';
import 'package:alquran_on_linux/domain/entities/content_manifest.dart';
import 'package:alquran_on_linux/domain/entities/reading_state.dart';
import 'package:alquran_on_linux/domain/entities/surah.dart';
import 'package:alquran_on_linux/domain/repositories/quran_content_repository.dart';
import 'package:alquran_on_linux/domain/repositories/user_state_repositories.dart';

/// Clearly synthetic fixture data — structural placeholders only, never
/// mistaken for approved content. Texts are ASCII markers, not verses.
class FakeQuranContentRepository implements QuranContentRepository {
  FakeQuranContentRepository({int surahCount = 3, int ayahsPerSurah = 4})
    : surahs = [
        for (int s = 1; s <= surahCount; s++)
          Surah(
            number: s,
            arabicName: 'سورة $s',
            latinName: 'Surah $s',
            verseCount: ayahsPerSurah,
          ),
      ],
      ayahs = {
        for (int s = 1; s <= surahCount; s++)
          s: [
            for (int a = 1; a <= ayahsPerSurah; a++)
              Ayah(
                key: AyahKey(surahNumber: s, ayahNumber: a),
                arabicText: 'PLACEHOLDER $s:$a',
              ),
          ],
      };

  final List<Surah> surahs;
  final Map<int, List<Ayah>> ayahs;

  @override
  Future<List<Surah>> getSurahs() async => List.unmodifiable(surahs);

  @override
  Future<Surah?> getSurah(int surahNumber) async =>
      surahs.where((s) => s.number == surahNumber).firstOrNull;

  @override
  Future<List<Ayah>> getAyahs(int surahNumber) async =>
      List.unmodifiable(ayahs[surahNumber] ?? const []);

  @override
  Future<String?> getTranslation(AyahKey key, String editionId) async =>
      'TRANSLATION $editionId ${key.surahNumber}:${key.ayahNumber}';

  @override
  Future<ContentManifest> getManifest() async => ContentManifest(
    arabicSource: 'fake',
    arabicEdition: 'fake-1',
    arabicSha256: 'fake',
    translationEditionId: 'fake-id',
    translationVersion: 'fake-1',
    translationSha256: 'fake',
    acquiredAt: DateTime.utc(2026, 10, 9),
    validationReportRef: 'fake-report',
  );
}

class FakeBookmarkRepository implements BookmarkRepository {
  final Map<AyahKey, Bookmark> _store = {};

  @override
  Future<List<Bookmark>> listBookmarks() async => _store.values.toList();

  @override
  Future<bool> isBookmarked(AyahKey key) async => _store.containsKey(key);

  @override
  Future<void> addBookmark(Bookmark bookmark) async {
    _store[bookmark.key] = bookmark;
  }

  @override
  Future<void> removeBookmark(AyahKey key) async {
    _store.remove(key);
  }
}

class FakeReadingProgressRepository implements ReadingProgressRepository {
  ReadingPosition? stored;

  @override
  Future<ReadingPosition?> loadLastRead() async => stored;

  @override
  Future<void> saveLastRead(ReadingPosition position) async {
    stored = position;
  }
}
