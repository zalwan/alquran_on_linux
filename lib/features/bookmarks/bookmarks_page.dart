import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database_providers.dart';
import '../../domain/entities/reading_state.dart';
import '../reader/reader_providers.dart';

/// Saved verses, newest first. Fully functional against the local database;
/// entries identify the verse by key until verse titles arrive with the
/// approved content.
class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<Bookmark>> bookmarks = ref.watch(
      bookmarksListProvider,
    );
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bookmarks', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Expanded(
            child: bookmarks.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No bookmarks yet. Open a surah and tap the bookmark '
                      'icon on any verse.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final Bookmark bookmark = items[index];
                    return ListTile(
                      leading: Icon(
                        Icons.bookmark,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        'Surah ${bookmark.key.surahNumber}, '
                        'Ayah ${bookmark.key.ayahNumber}',
                      ),
                      trailing: IconButton(
                        tooltip: 'Remove bookmark',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await ref
                              .read(bookmarkRepositoryProvider)
                              .removeBookmark(bookmark.key);
                          ref.invalidate(bookmarksListProvider);
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: Text(
                  'Could not load bookmarks.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
