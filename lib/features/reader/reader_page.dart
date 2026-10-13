import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../app/router.dart';
import '../../app/theme/app_typography.dart';
import '../../app/widgets/content_unavailable.dart';
import '../../core/format/arabic_numerals.dart';
import '../../core/preferences/settings_providers.dart';
import '../../data/database/database_providers.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/reading_state.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../../domain/repositories/user_state_repositories.dart';
import '../../domain/usecases/open_surah.dart';
import '../../domain/usecases/reading_progress.dart';
import 'reader_providers.dart';

/// Verse-by-verse reader for one surah.
///
/// Interaction rule (MVP): opening a surah records its first verse as the
/// last-read location, unless a position in the same surah already exists
/// (e.g. after a manual jump) — then it is kept and revealed. Cards follow
/// `docs/theme.md` §7.3 with traditional ۝ end-of-verse markers. No
/// separate basmalah header: the approved text carries the basmalah inline
/// in verse 1 (except At-Taubah, which has none) and must be shown verbatim.
class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _LoadedSurah {
  const _LoadedSurah({
    required this.surah,
    required this.verses,
    required this.previous,
    required this.next,
  });

  final Surah surah;
  final List<Ayah> verses;
  final Surah? previous;
  final Surah? next;
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  final ItemScrollController _scroll = ItemScrollController();
  final TextEditingController _jumpField = TextEditingController();
  Future<_LoadedSurah>? _load;
  bool _loadRequested = false;
  int? _pendingScroll;
  String? _jumpError;

  @override
  void initState() {
    super.initState();
    // Record last-read after the first frame so providers are ready.
    // Invalid surah numbers never reach the repository: OpenSurah rejects
    // them during build and the error state is shown instead.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recordLastRead();
    });
  }

  @override
  void dispose() {
    _jumpField.dispose();
    super.dispose();
  }

  /// Same page, different surah (prev/next, deep link): drop the cached
  /// future and re-record last-read, or stale verses stay on screen.
  @override
  void didUpdateWidget(covariant ReaderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahNumber != widget.surahNumber) {
      _load = null;
      _loadRequested = false;
      _pendingScroll = null;
      _jumpError = null;
      _jumpField.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recordLastRead();
      });
    }
  }

  Future<void> _recordLastRead() async {
    if (!mounted) {
      return;
    }
    if (widget.surahNumber < 1 || widget.surahNumber > 114) {
      return;
    }
    if (ref.read(quranContentProvider) == null) {
      return;
    }
    final ReadingProgressRepository progress = ref.read(
      readingProgressRepositoryProvider,
    );
    final ReadingPosition? current = await RestoreLastRead(progress)();
    if (!mounted) {
      return;
    }
    if (current?.key.surahNumber == widget.surahNumber) {
      // Revisiting: keep the saved verse and reveal it.
      setState(() => _pendingScroll = current!.key.ayahNumber);
    } else {
      await UpdateLastRead(progress)(
        AyahKey(surahNumber: widget.surahNumber, ayahNumber: 1),
      );
      if (mounted) {
        ref.invalidate(lastReadProvider);
      }
    }
  }

  Future<_LoadedSurah> _loadSurah(QuranContentRepository content) async {
    final List<Ayah> verses = await OpenSurah(content)(widget.surahNumber);
    final Surah? surah = await content.getSurah(widget.surahNumber);
    if (surah == null) {
      throw StateError('Surah ${widget.surahNumber} missing from dataset.');
    }
    final Surah? previous = widget.surahNumber > 1
        ? await content.getSurah(widget.surahNumber - 1)
        : null;
    final Surah? next = widget.surahNumber < 114
        ? await content.getSurah(widget.surahNumber + 1)
        : null;
    return _LoadedSurah(
      surah: surah,
      verses: verses,
      previous: previous,
      next: next,
    );
  }

  Future<void> _jumpTo(String raw, int verseCount) async {
    final int? ayah = int.tryParse(raw.trim());
    if (ayah == null || ayah < 1 || ayah > verseCount) {
      setState(() => _jumpError = 'Enter a number between 1 and $verseCount.');
      return;
    }
    setState(() => _jumpError = null);
    _jumpField.clear();
    final ReadingProgressRepository progress = ref.read(
      readingProgressRepositoryProvider,
    );
    await UpdateLastRead(progress)(
      AyahKey(surahNumber: widget.surahNumber, ayahNumber: ayah),
    );
    ref.invalidate(lastReadProvider);
    _reveal(ayah);
  }

  void _reveal(int ayah) {
    // Header occupies list index 0, so verse N lives at index N.
    setState(() => _pendingScroll = ayah);
  }

  @override
  Widget build(BuildContext context) {
    final QuranContentRepository? content = ref.watch(quranContentProvider);
    if (content == null) {
      return const ContentUnavailable();
    }
    if (!_loadRequested) {
      _loadRequested = true;
      try {
        _load = _loadSurah(content);
      } on RangeError {
        _load = Future.error('Surah ${widget.surahNumber} is outside 1–114.');
      }
    }
    return FutureBuilder<_LoadedSurah>(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return ContentUnavailable(detail: snapshot.error?.toString());
        }
        final _LoadedSurah loaded = snapshot.data!;
        if (_pendingScroll != null && _scroll.isAttached) {
          final int target = _pendingScroll!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scroll.isAttached) {
              _scroll.scrollTo(
                index: target,
                alignment: 0.15,
                duration: const Duration(milliseconds: 400),
              );
            }
          });
          _pendingScroll = null;
        }
        return Column(
          children: [
            _SurahHeader(
              surah: loaded.surah,
              jumpField: _jumpField,
              jumpError: _jumpError,
              onJump: (raw) => _jumpTo(raw, loaded.surah.verseCount),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: loaded.verses.length + 1,
                itemScrollController: _scroll,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox(height: 8);
                  }
                  return _VerseCard(
                    content: content,
                    verse: loaded.verses[index - 1],
                  );
                },
              ),
            ),
            _SurahFooter(previous: loaded.previous, next: loaded.next),
          ],
        );
      },
    );
  }
}

class _SurahHeader extends ConsumerWidget {
  const _SurahHeader({
    required this.surah,
    required this.jumpField,
    required this.jumpError,
    required this.onJump,
  });

  final Surah surah;
  final TextEditingController jumpField;
  final String? jumpError;
  final void Function(String raw) onJump;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        border: Border(bottom: BorderSide(color: scheme.outline)),
      ),
      child: Column(
        children: [
          Text(
            surah.arabicName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTypography.arabicFontFamily,
              fontSize: 32,
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${surah.latinName} · ${surah.verseCount} verses',
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: jumpField,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Go to ayah…',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: onJump,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => onJump(jumpField.text),
                child: const Text('Go'),
              ),
            ],
          ),
          if (jumpError != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(jumpError!, style: TextStyle(color: scheme.error)),
            ),
        ],
      ),
    );
  }
}

class _SurahFooter extends StatelessWidget {
  const _SurahFooter({required this.previous, required this.next});

  final Surah? previous;
  final Surah? next;

  @override
  Widget build(BuildContext context) {
    if (previous == null && next == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (previous != null)
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.reader(previous!.number)),
              child: Text('‹ ${previous!.latinName}'),
            )
          else
            const SizedBox.shrink(),
          if (next != null)
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.reader(next!.number)),
              child: Text('${next!.latinName} ›'),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _VerseCard extends ConsumerWidget {
  const _VerseCard({required this.content, required this.verse});

  final QuranContentRepository content;
  final Ayah verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final double arabicSize = ref.watch(arabicFontSizeSettingProvider);
    final ReadingPosition? lastRead = ref
        .watch(lastReadProvider)
        .maybeWhen(data: (position) => position, orElse: () => null);
    final AsyncValue<List<Bookmark>> bookmarks = ref.watch(
      bookmarksListProvider,
    );
    final List<Bookmark> bookmarked = bookmarks.maybeWhen(
      data: (items) => items,
      orElse: () => const <Bookmark>[],
    );
    final bool isBookmarked = bookmarked.any((b) => b.key == verse.key);
    final bool highlighted = lastRead?.key == verse.key;

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
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: verse.arabicText),
                      TextSpan(text: ayahMarker(verse.key.ayahNumber)),
                    ],
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppTypography.arabicFontFamily,
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
