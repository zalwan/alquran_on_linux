import 'package:flutter/material.dart';

/// Phase 1 placeholder. The surah index and reader arrive in Phase 2 with
/// approved content — this screen must not display any Quran text.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              Icons.menu_book_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Alquran', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Surah index and reader arrive in Phase 2.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
