import 'package:drift/drift.dart';

import '../../domain/entities/ayah.dart';
import '../../domain/entities/reading_state.dart';
import '../../domain/repositories/user_state_repositories.dart';
import '../database/app_database.dart';

/// [BookmarkRepository] backed by the `bookmarks` table.
class DriftBookmarkRepository implements BookmarkRepository {
  DriftBookmarkRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Bookmark>> listBookmarks() async {
    final rows = await (_db.select(
      _db.bookmarks,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    return [
      for (final row in rows)
        Bookmark(
          key: AyahKey(
            surahNumber: row.surahNumber,
            ayahNumber: row.ayahNumber,
          ),
          createdAt: row.createdAt,
        ),
    ];
  }

  @override
  Future<bool> isBookmarked(AyahKey key) async {
    final row =
        await (_db.select(_db.bookmarks)..where(
              (t) =>
                  t.surahNumber.equals(key.surahNumber) &
                  t.ayahNumber.equals(key.ayahNumber),
            ))
            .getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> addBookmark(Bookmark bookmark) {
    return _db
        .into(_db.bookmarks)
        .insertOnConflictUpdate(
          BookmarksCompanion.insert(
            surahNumber: bookmark.key.surahNumber,
            ayahNumber: bookmark.key.ayahNumber,
            createdAt: bookmark.createdAt,
          ),
        );
  }

  @override
  Future<void> removeBookmark(AyahKey key) {
    return (_db.delete(_db.bookmarks)..where(
          (t) =>
              t.surahNumber.equals(key.surahNumber) &
              t.ayahNumber.equals(key.ayahNumber),
        ))
        .go();
  }
}

/// [ReadingProgressRepository] backed by the singleton `reading_positions`
/// row (id 1). Upserts keep exactly one row — a missing row means first
/// launch, never an error.
class DriftReadingProgressRepository implements ReadingProgressRepository {
  DriftReadingProgressRepository(this._db);

  final AppDatabase _db;

  @override
  Future<ReadingPosition?> loadLastRead() async {
    final row = await (_db.select(
      _db.readingPositions,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    return ReadingPosition(
      key: AyahKey(surahNumber: row.surahNumber, ayahNumber: row.ayahNumber),
      updatedAt: row.updatedAt,
    );
  }

  @override
  Future<void> saveLastRead(ReadingPosition position) {
    return _db
        .into(_db.readingPositions)
        .insertOnConflictUpdate(
          ReadingPositionsCompanion.insert(
            id: const Value(1),
            surahNumber: position.key.surahNumber,
            ayahNumber: position.key.ayahNumber,
            updatedAt: position.updatedAt,
          ),
        );
  }
}
