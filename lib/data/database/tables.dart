import 'package:drift/drift.dart';

/// Locally saved verse markers. Composite key — one row per verse.
/// Stores keys only, never verse text.
@DataClassName('BookmarkRow')
class Bookmarks extends Table {
  IntColumn get surahNumber => integer()();

  IntColumn get ayahNumber => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {surahNumber, ayahNumber};
}

/// Singleton row (id always 1): the most recently read location.
@DataClassName('ReadingPositionRow')
class ReadingPositions extends Table {
  IntColumn get id => integer()();

  IntColumn get surahNumber => integer()();

  IntColumn get ayahNumber => integer()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
