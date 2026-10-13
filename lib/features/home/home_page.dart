import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../domain/entities/reading_state.dart';
import '../reader/reader_providers.dart';

/// Home dashboard: product identity, continue-reading entry point, library
/// stats, and shortcuts. Content-independent parts (stats, shortcuts) work
/// even before first launch reading; the surah count appears once seeded.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<ReadingPosition?> lastRead = ref.watch(lastReadProvider);
    final AsyncValue<List<Bookmark>> bookmarks = ref.watch(
      bookmarksListProvider,
    );
    final int bookmarkCount = bookmarks.maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.all(24),
          shrinkWrap: true,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Alquran',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Calm offline reading',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            lastRead.maybeWhen(
              data: (position) {
                if (position == null) {
                  return const SizedBox.shrink();
                }
                return _ContinueCard(position: position);
              },
              orElse: () => const SizedBox.shrink(),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(
                  Icons.library_books_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Browse the surah index'),
                subtitle: const Text('All 114 surahs, offline'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(AppRoutes.surahs),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(
                  Icons.bookmark_border,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Bookmarks'),
                subtitle: Text(
                  bookmarkCount == 0
                      ? 'No saved verses yet'
                      : '$bookmarkCount saved verse${bookmarkCount == 1 ? '' : 's'}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(AppRoutes.bookmarks),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.position});

  final ReadingPosition position;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Continue reading',
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Surah ${position.key.surahNumber}, '
            'Ayah ${position.key.ayahNumber}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () =>
                context.go(AppRoutes.reader(position.key.surahNumber)),
            child: const Text('Continue reading'),
          ),
        ],
      ),
    );
  }
}
