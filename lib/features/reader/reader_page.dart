import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/content_unavailable.dart';
import '../../core/preferences/settings_providers.dart';
import '../../data/database/database_providers.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/reading_state.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../../domain/repositories/user_state_repositories.dart';
import '../../domain/usecases/open_surah.dart';
import '../../domain/usecases/reading_progress.dart';
import 'reader_providers.dart';

/// Verse-by-verse reader for one surah.
///
/// Interaction rule (MVP): opening a surah records its first verse as the
/// last-read location; the last-read verse is highlighted. Verse cards
/// follow `docs/theme.md` §7.3: number badge, RTL Arabic at the user's
/// size, dimmed translation, bookmark action, highlight on the active verse.
class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  late final Future<List<Ayah>> _verses;
  bool _versesRequested = false;

  @override
  void initState() {
    super.initState();
    // Record last-read after the first frame so providers are ready.
    // Invalid surah numbers never reach the repository: OpenSurah rejects
    // them during build and the error state is shown instead.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (widget.surahNumber < 1 || widget.surahNumber > 114) {
        return;
      }
      final QuranContentRepository? content = ref.read(quranContentProvider);
      if (content == null) {
        return;
      }
      final ReadingProgressRepository repo = ref.read(
        readingProgressRepositoryProvider,
      );
      UpdateLastRead(repo)(
        AyahKey(surahNumber: widget.surahNumber, ayahNumber: 1),
      ).then((_) {
        if (mounted) {
          ref.invalidate(lastReadProvider);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final QuranContentRepository? content = ref.watch(quranContentProvider);
    if (content == null) {
      return const ContentUnavailable();
    }
    if (!_versesRequested) {
      _versesRequested = true;
      try {
        _verses = OpenSurah(content)(widget.surahNumber);
      } on RangeError {
        _verses = Future.error('Surah ${widget.surahNumber} is outside 1–114.');
      }
    }
    return FutureBuilder<List<Ayah>>(
      future: _verses,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return ContentUnavailable(detail: snapshot.error?.toString());
        }
        return _VerseList(content: content, verses: snapshot.data!);
      },
    );
  }
}

class _VerseList extends ConsumerWidget {
  const _VerseList({required this.content, required this.verses});

  final QuranContentRepository content;
  final List<Ayah> verses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double arabicSize = ref.watch(arabicFontSizeSettingProvider);
    final ReadingPosition? lastRead = ref
        .watch(lastReadProvider)
        .maybeWhen(data: (position) => position, orElse: () => null);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final Ayah verse = verses[index];
        final bool highlighted = lastRead?.key == verse.key;
        return _VerseCard(
          content: content,
          verse: verse,
          arabicSize: arabicSize,
          highlighted: highlighted,
        );
      },
    );
  }
}

class _VerseCard extends ConsumerWidget {
  const _VerseCard({
    required this.content,
    required this.verse,
    required this.arabicSize,
    required this.highlighted,
  });

  final QuranContentRepository content;
  final Ayah verse;
  final double arabicSize;
  final bool highlighted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AsyncValue<List<Bookmark>> bookmarks = ref.watch(
      bookmarksListProvider,
    );
    final List<Bookmark> bookmarked = bookmarks.maybeWhen(
      data: (items) => items,
      orElse: () => const <Bookmark>[],
    );
    final bool isBookmarked = bookmarked.any((b) => b.key == verse.key);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: highlighted
          ? BoxDecoration(
              color: scheme.primaryContainer,
              border: Border(left: BorderSide(color: scheme.primary, width: 3)),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: Text(
                  '${verse.key.ayahNumber}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  verse.arabicText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: arabicSize,
                    height: 2.0,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                tooltip: isBookmarked
                    ? 'Remove bookmark'
                    : 'Bookmark this verse',
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? scheme.primary : null,
                ),
                onPressed: () async {
                  final BookmarkRepository repo = ref.read(
                    bookmarkRepositoryProvider,
                  );
                  await ToggleBookmark(repo)(verse.key);
                  ref.invalidate(bookmarksListProvider);
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          FutureBuilder<String?>(
            future: content.getTranslation(verse.key, readerEditionId),
            builder: (context, snapshot) {
              final String? translation = snapshot.data;
              if (translation == null || translation.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(left: 40, right: 4),
                child: Text(
                  translation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
