import '../entities/ayah.dart';
import '../entities/reading_state.dart';
import '../repositories/user_state_repositories.dart';

/// Toggle a bookmark for [key]. Returns true when the verse ends up
/// bookmarked, false when the bookmark was removed.
class ToggleBookmark {
  const ToggleBookmark(this._bookmarks, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final BookmarkRepository _bookmarks;
  final DateTime Function() _clock;

  Future<bool> call(AyahKey key) async {
    if (await _bookmarks.isBookmarked(key)) {
      await _bookmarks.removeBookmark(key);
      return false;
    }
    await _bookmarks.addBookmark(Bookmark(key: key, createdAt: _clock()));
    return true;
  }
}

/// Persist the reader's current location.
class UpdateLastRead {
  const UpdateLastRead(this._progress, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final ReadingProgressRepository _progress;
  final DateTime Function() _clock;

  Future<void> call(AyahKey key) {
    return _progress.saveLastRead(
      ReadingPosition(key: key, updatedAt: _clock()),
    );
  }
}

/// Restore the persisted location, or null on first launch.
class RestoreLastRead {
  const RestoreLastRead(this._progress);

  final ReadingProgressRepository _progress;

  Future<ReadingPosition?> call() => _progress.loadLastRead();
}
