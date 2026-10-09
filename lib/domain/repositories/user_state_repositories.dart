import '../entities/ayah.dart';
import '../entities/reading_state.dart';

/// Local bookmark storage. Keys always identify the correct surah and ayah.
abstract class BookmarkRepository {
  Future<List<Bookmark>> listBookmarks();

  Future<bool> isBookmarked(AyahKey key);

  Future<void> addBookmark(Bookmark bookmark);

  Future<void> removeBookmark(AyahKey key);
}

/// Local last-read persistence. Must survive app restarts.
abstract class ReadingProgressRepository {
  Future<ReadingPosition?> loadLastRead();

  Future<void> saveLastRead(ReadingPosition position);
}
