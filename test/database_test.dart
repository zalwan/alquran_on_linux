import 'dart:io';

import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/repositories/drift_user_state.dart';
import 'package:alquran_on_linux/domain/entities/ayah.dart';
import 'package:alquran_on_linux/domain/entities/reading_state.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase memoryDb() {
  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  return db;
}

void main() {
  test('database opens with schema version 1', () async {
    final AppDatabase db = memoryDb();
    expect(db.schemaVersion, 1);
    final rows = await db.customSelect('SELECT 1 AS one').get();
    expect(rows.single.read<int>('one'), 1);
  });

  group('DriftBookmarkRepository', () {
    test('add, list in order, contains, remove', () async {
      final repo = DriftBookmarkRepository(memoryDb());
      const first = AyahKey(surahNumber: 2, ayahNumber: 255);
      const second = AyahKey(surahNumber: 1, ayahNumber: 1);

      expect(await repo.isBookmarked(first), isFalse);
      await repo.addBookmark(
        Bookmark(key: second, createdAt: DateTime.utc(2026, 1, 2)),
      );
      await repo.addBookmark(
        Bookmark(key: first, createdAt: DateTime.utc(2026, 1, 1)),
      );
      // Re-adding refreshes the row instead of duplicating it.
      await repo.addBookmark(
        Bookmark(key: first, createdAt: DateTime.utc(2026, 1, 3)),
      );

      final listed = await repo.listBookmarks();
      expect(listed.map((b) => b.key), [second, first]);
      expect(await repo.isBookmarked(first), isTrue);

      await repo.removeBookmark(first);
      expect(await repo.isBookmarked(first), isFalse);
      expect((await repo.listBookmarks()).map((b) => b.key), [second]);
    });
  });

  group('DriftReadingProgressRepository', () {
    test('null on first launch, then upserts a single row', () async {
      final repo = DriftReadingProgressRepository(memoryDb());

      expect(await repo.loadLastRead(), isNull);

      await repo.saveLastRead(
        ReadingPosition(
          key: const AyahKey(surahNumber: 1, ayahNumber: 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      );
      await repo.saveLastRead(
        ReadingPosition(
          key: const AyahKey(surahNumber: 114, ayahNumber: 6),
          updatedAt: DateTime.utc(2026, 1, 2),
        ),
      );

      expect(
        await repo.loadLastRead(),
        ReadingPosition(
          key: const AyahKey(surahNumber: 114, ayahNumber: 6),
          updatedAt: DateTime.utc(2026, 1, 2),
        ),
      );
    });

    test('bookmarks and last-read survive an app restart', () async {
      final Directory dir = await Directory.systemTemp.createTemp(
        'alquran-restart',
      );
      addTearDown(() => dir.delete(recursive: true));
      File file() => File('${dir.path}/alquran.db');

      final AppDatabase first = AppDatabase(file());
      await DriftBookmarkRepository(first).addBookmark(
        Bookmark(
          key: const AyahKey(surahNumber: 2, ayahNumber: 255),
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      );
      await DriftReadingProgressRepository(first).saveLastRead(
        ReadingPosition(
          key: const AyahKey(surahNumber: 2, ayahNumber: 255),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      );
      await first.close();

      // "Restart": a new connection over the same file sees everything.
      final AppDatabase second = AppDatabase(file());
      addTearDown(second.close);

      expect(
        await DriftBookmarkRepository(
          second,
        ).isBookmarked(const AyahKey(surahNumber: 2, ayahNumber: 255)),
        isTrue,
      );
      expect(
        (await DriftReadingProgressRepository(second).loadLastRead())?.key,
        const AyahKey(surahNumber: 2, ayahNumber: 255),
      );
    });
  });
}
