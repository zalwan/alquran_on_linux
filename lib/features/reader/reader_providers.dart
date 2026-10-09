import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database_providers.dart';
import '../../domain/entities/reading_state.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../../domain/repositories/user_state_repositories.dart';
import '../../domain/usecases/reading_progress.dart';

/// Read access to approved Quran content, or null while the content gate
/// is closed.
///
/// Production override arrives with the approved dataset (Phase 2 content
/// gate — see `docs/translation-clearance.md`). Screens branch on null and
/// show [ContentUnavailable] instead of crashing. Tests override with an
/// in-memory fake.
final quranContentProvider = Provider<QuranContentRepository?>((ref) => null);

/// Translation edition shown under each verse. Finalized with the approved
/// edition (TODO content gate); the fake backend ignores it.
const String readerEditionId = 'pending-edition';

/// All bookmarks, refreshed by invalidating after every toggle/remove.
final bookmarksListProvider = FutureProvider<List<Bookmark>>((ref) {
  final BookmarkRepository repo = ref.watch(bookmarkRepositoryProvider);
  return repo.listBookmarks();
});

/// Last-read location, or null on first launch / load failure.
final lastReadProvider = FutureProvider<ReadingPosition?>((ref) {
  final ReadingProgressRepository repo = ref.watch(
    readingProgressRepositoryProvider,
  );
  return RestoreLastRead(repo)();
});
