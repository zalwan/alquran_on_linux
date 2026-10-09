import 'package:alquran_on_linux/domain/entities/ayah.dart';
import 'package:alquran_on_linux/domain/entities/content_manifest.dart';
import 'package:alquran_on_linux/domain/entities/reading_state.dart';
import 'package:alquran_on_linux/domain/entities/surah.dart';
import 'package:alquran_on_linux/domain/entities/translation.dart';
import 'package:alquran_on_linux/domain/usecases/open_surah.dart';
import 'package:alquran_on_linux/domain/usecases/reading_progress.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('identifiers and entities', () {
    test('AyahKey equality is by value', () {
      expect(
        const AyahKey(surahNumber: 2, ayahNumber: 255),
        const AyahKey(surahNumber: 2, ayahNumber: 255),
      );
      expect(
        const AyahKey(surahNumber: 2, ayahNumber: 255),
        isNot(const AyahKey(surahNumber: 2, ayahNumber: 256)),
      );
    });

    test('invalid identifiers throw', () {
      expect(() => AyahKey.checkValid(0, 1), throwsRangeError);
      expect(() => AyahKey.checkValid(115, 1), throwsRangeError);
      expect(() => AyahKey.checkValid(1, 0), throwsArgumentError);
      expect(
        () => Surah(number: 0, arabicName: 'x', latinName: 'y', verseCount: 7),
        throwsRangeError,
      );
      expect(
        () => Surah(number: 1, arabicName: 'x', latinName: 'y', verseCount: 0),
        throwsArgumentError,
      );
      expect(
        () => Ayah(
          key: const AyahKey(surahNumber: 1, ayahNumber: 1),
          arabicText: '',
        ),
        throwsArgumentError,
      );
      expect(
        () => ContentManifest(
          arabicSource: '',
          arabicEdition: 'e',
          arabicSha256: 's',
          translationEditionId: 't',
          translationVersion: 'v',
          translationSha256: 's',
          acquiredAt: DateTime.utc(2026, 1, 1),
          validationReportRef: 'r',
        ),
        throwsArgumentError,
      );
    });

    test('translation rows require edition and text', () {
      expect(
        () => AyahTranslation(
          key: const AyahKey(surahNumber: 1, ayahNumber: 1),
          editionId: '',
          text: 'x',
        ),
        throwsArgumentError,
      );
    });
  });

  group('OpenSurah', () {
    test('returns verses in order without gaps', () async {
      final repo = FakeQuranContentRepository();
      final verses = await OpenSurah(repo)(2);

      expect(verses, hasLength(4));
      expect(verses.map((v) => v.key.ayahNumber), [1, 2, 3, 4]);
    });

    test('rejects numbers outside 1-114 before touching the repository', () {
      final repo = FakeQuranContentRepository();
      expect(() => OpenSurah(repo)(0), throwsRangeError);
      expect(() => OpenSurah(repo)(115), throwsRangeError);
    });
  });

  group('bookmarks and progress', () {
    test('toggle adds then removes the same key', () async {
      final repo = FakeBookmarkRepository();
      final toggle = ToggleBookmark(repo);
      const key = AyahKey(surahNumber: 1, ayahNumber: 2);

      expect(await toggle(key), isTrue);
      expect(await repo.isBookmarked(key), isTrue);
      expect(await toggle(key), isFalse);
      expect(await repo.isBookmarked(key), isFalse);
      expect(await repo.listBookmarks(), isEmpty);
    });

    test('last-read round-trips with the clock time', () async {
      final progress = FakeReadingProgressRepository();
      final fixed = DateTime.utc(2026, 10, 9, 12);
      const key = AyahKey(surahNumber: 114, ayahNumber: 6);

      expect(await RestoreLastRead(progress)(), isNull);
      await UpdateLastRead(progress, clock: () => fixed)(key);

      expect(
        await RestoreLastRead(progress)(),
        ReadingPosition(key: key, updatedAt: fixed),
      );
    });
  });
}
