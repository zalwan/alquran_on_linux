import 'package:flutter/material.dart';

/// Shown whenever approved content cannot be served — content gate still
/// closed, or a corrupt/missing local dataset in production. Never a crash,
/// never a silent blank screen.
class ContentUnavailable extends StatelessWidget {
  const ContentUnavailable({super.key, this.detail});

  final String? detail;

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
              Icons.cloud_off_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Quran content is not available yet',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              detail ??
                  'The approved edition has not been bundled with this '
                      'build. Bookmarks, theme, and settings keep working.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
