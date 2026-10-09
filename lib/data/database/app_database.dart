import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables.dart';

import 'content_tables.dart';

part 'app_database.g.dart';

/// Local database: user state only in Phase 2a (bookmarks, last read).
/// Versioned Quran content tables arrive with the approved dataset — see
/// `architecture.md` §6 and ADR-0004. Content and user state stay in
/// separate tables so content updates never endanger user data.
@DriftDatabase(
  tables: [
    Bookmarks,
    ReadingPositions,
    Surahs,
    Ayahs,
    AyahTranslations,
    ContentMeta,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(File file) : super(_open(file));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _open(File file) {
    return NativeDatabase.createInBackground(file);
  }
}
