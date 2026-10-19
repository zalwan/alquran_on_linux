import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/app_typography.dart';
import '../../app/widgets/content_unavailable.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../reader/reader_providers.dart';
import 'revelation_label.dart';

/// Compact subtitle for a surah row: verse count with the Indonesian
/// revelation label when known.
String _rowSubtitle(Surah surah) {
  final String? label = revelationLabel(surah.revelationType);
  final String count = surah.verseCount == 1
      ? '1 verse'
      : '${surah.verseCount} verses';
  return label == null ? count : '$count · $label';
}

/// Canonical 114-surah list in source order. Served by
/// [quranContentProvider]; shows [ContentUnavailable] while the gate is
/// closed instead of failing.
class SurahIndexPage extends ConsumerWidget {
  const SurahIndexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color gold = theme.brightness == Brightness.dark
        ? AppColors.darkGold
        : AppColors.gold;
    final QuranContentRepository? content = ref.watch(quranContentProvider);
    if (content == null) {
      return const ContentUnavailable();
    }
    return FutureBuilder<List<Surah>>(
      future: content.getSurahs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const ContentUnavailable();
        }
        final List<Surah> items = snapshot.data!;
        if (items.isEmpty) {
          return const ContentUnavailable(
            detail:
                'The content database holds no surahs — first-launch '
                'seeding may have failed. Bookmarks, theme, and settings '
                'keep working.',
          );
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final Surah surah = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      onTap: () =>
                          context.go('${AppRoutes.surahs}/${surah.number}'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: scheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: gold.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Text(
                                '${surah.number}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    surah.latinName,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _rowSubtitle(surah),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurface.withValues(
                                        alpha: 0.65,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              surah.arabicName,
                              textDirection: TextDirection.rtl,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontFamily: AppTypography.arabicFontFamily,
                                color: gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
