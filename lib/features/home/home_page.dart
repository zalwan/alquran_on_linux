import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/widgets/islamic_pattern.dart';
import '../../core/preferences/settings_providers.dart';
import '../../domain/entities/reading_state.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../reader/reader_providers.dart';

/// Opens a random surah from the seeded catalogue (data-driven count, so a
/// corrupted manifest can only navigate to existing surahs).
Future<void> _openRandomSurah(BuildContext context, WidgetRef ref) async {
  final QuranContentRepository? content = ref.read(quranContentProvider);
  if (content == null) {
    return;
  }
  final int count = (await content.getSurahs()).length;
  if (count < 1 || !context.mounted) {
    return;
  }
  context.go(AppRoutes.reader(1 + math.Random().nextInt(count)));
}

/// Home dashboard: patterned hero, continue-reading entry point, library
/// stats, and shortcuts.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AsyncValue<ReadingPosition?> lastRead = ref.watch(lastReadProvider);
    final AsyncValue<List<Bookmark>> bookmarks = ref.watch(
      bookmarksListProvider,
    );
    final int bookmarkCount = bookmarks.maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );
    final double fontSize = ref.watch(arabicFontSizeSettingProvider);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.all(24),
          shrinkWrap: true,
          children: [
            _HeroCard(
              position: lastRead.maybeWhen(
                data: (position) => position,
                orElse: () => null,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.library_books_outlined,
                    value: '114',
                    label: 'Surahs offline',
                    onTap: () => context.go(AppRoutes.surahs),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.bookmark_border,
                    value: '$bookmarkCount',
                    label: bookmarkCount == 1 ? 'Bookmark' : 'Bookmarks',
                    onTap: () => context.go(AppRoutes.bookmarks),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.text_fields,
                    value: fontSize.toStringAsFixed(0),
                    label: 'Arabic size',
                    onTap: () => context.go(AppRoutes.settings),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Light and dark themes follow your desktop; adjust them '
              'any time in Settings.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends ConsumerWidget {
  const _HeroCard({required this.position});

  final ReadingPosition? position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: IslamicPattern(
                color: scheme.primary.withValues(alpha: 0.14),
                cell: 48,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 32,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Alquran',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Calm offline reading',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                if (position != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Surah ${position!.key.surahNumber}, '
                    'Ayah ${position!.key.ayahNumber}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go(
                            AppRoutes.reader(position!.key.surahNumber),
                          ),
                          child: const Text('Continue reading'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openRandomSurah(context, ref),
                          icon: const Icon(Icons.shuffle),
                          label: const Text('Surprise me'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.surahs),
                    child: const Text('Browse the surah index'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
