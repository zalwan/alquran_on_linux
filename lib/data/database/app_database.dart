import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'app_database.g.dart';

/// Local database skeleton (Phase 1).
///
/// Opens the persistence layer and pins the migration contract
/// (`schemaVersion`). Content tables (surah/ayah/translation) and user-state
/// tables (bookmarks, reading position) arrive in Phase 2 behind repository
/// interfaces — see `architecture.md` §4–§6 and ADR-0004.
@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _open() {
    // Production path resolution (path_provider) is wired in Phase 2 when
    // the first table lands. The in-memory executor keeps this constructor
    // honest until then and is never used with real user data.
    return NativeDatabase.memory();
  }
}
