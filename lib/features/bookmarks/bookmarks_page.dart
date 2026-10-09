import 'package:flutter/material.dart';

/// Phase 1 placeholder. Bookmark storage arrives in Phase 2.
class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Bookmarks', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Saved verses will appear here in Phase 2.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
