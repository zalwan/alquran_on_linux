import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/user_state_repositories.dart';
import '../database/app_database.dart';
import '../repositories/drift_user_state.dart';

/// Database override installed once in `main()` with the real file-backed
/// instance. Tests override with `AppDatabase.forTesting`.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('appDatabaseProvider not set'),
);

final bookmarkRepositoryProvider = Provider<BookmarkRepository>(
  (ref) => DriftBookmarkRepository(ref.watch(appDatabaseProvider)),
);

final readingProgressRepositoryProvider = Provider<ReadingProgressRepository>(
  (ref) => DriftReadingProgressRepository(ref.watch(appDatabaseProvider)),
);
