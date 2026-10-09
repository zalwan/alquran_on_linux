import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/widgets/content_unavailable.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../reader/reader_providers.dart';

/// Canonical 114-surah list in source order. Served by
/// [quranContentProvider]; shows [ContentUnavailable] while the gate is
/// closed instead of failing.
class SurahIndexPage extends ConsumerWidget {
  const SurahIndexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
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
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final Surah surah = items[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: Text('${surah.number}'),
                ),
                title: Text(surah.latinName),
                subtitle: Text('${surah.verseCount} verses'),
                trailing: Text(
                  surah.arabicName,
                  style: theme.textTheme.titleLarge,
                ),
                onTap: () => context.go('${AppRoutes.surahs}/${surah.number}'),
              ),
            );
          },
        );
      },
    );
  }
}
