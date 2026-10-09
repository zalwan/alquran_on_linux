import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../reader/reader_providers.dart';

/// Home: product identity plus a continue-reading entry point. Without a
/// saved position it stays a quiet placeholder; the surah index and reader
/// arrive with the approved content (Phase 2 content gate).
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final lastRead = ref.watch(lastReadProvider);
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
            lastRead.when(
              data: (position) {
                if (position == null) {
                  return Text(
                    'Surah index and reader arrive in Phase 2.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Continue reading: Surah ${position.key.surahNumber}, '
                      'Ayah ${position.key.ayahNumber}',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.go(
                        AppRoutes.reader(position.key.surahNumber),
                      ),
                      child: const Text('Continue reading'),
                    ),
                  ],
                );
              },
              loading: () => Text(
                'Surah index and reader arrive in Phase 2.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              error: (_, _) => Text(
                'Surah index and reader arrive in Phase 2.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
