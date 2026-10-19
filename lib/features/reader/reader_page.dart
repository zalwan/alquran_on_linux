import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/widgets/content_unavailable.dart';
import '../../app/widgets/indonesian_ornament.dart';
import '../../core/format/basmalah.dart';
import '../../core/preferences/preferences_repository.dart';
import '../../core/preferences/settings_providers.dart';
import '../../data/database/database_providers.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/reading_state.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../../domain/repositories/user_state_repositories.dart';
import '../../domain/usecases/open_surah.dart';
import '../../domain/usecases/reading_progress.dart';
import '../surah_index/revelation_label.dart';
import 'reader_providers.dart';

/// Verse-by-verse reader for one surah.
///
/// Interaction rule (MVP): opening a surah records its first verse as the
/// last-read location, unless a position in the same surah already exists
/// (e.g. after a manual jump) — then it is kept and revealed. Arrow/J/K
/// keys, Home, and End move the reading position; `/` focuses the
/// jump field; `Esc` returns to the index. Cards follow `docs/theme.md`
/// §7.3 with traditional ۝ end-of-verse markers. No separate basmalah
/// header: the approved text carries the basmalah inline in verse 1
/// (except At-Taubah, which has none) and must be shown verbatim.
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

class _MoveAyahIntent extends Intent {
  const _MoveAyahIntent(this.delta);
  final int delta;
}

class _EdgeAyahIntent extends Intent {
  const _EdgeAyahIntent(this.first);
  final bool first;
}

class _FocusJumpIntent extends Intent {
  const _FocusJumpIntent();
}

class _BackToIndexIntent extends Intent {
  const _BackToIndexIntent();
}

class _ShowShortcutsIntent extends Intent {
  const _ShowShortcutsIntent();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  final ItemScrollController _scroll = ItemScrollController();
  final ItemPositionsListener _positions = ItemPositionsListener.create();
  final TextEditingController _jumpField = TextEditingController();
  final FocusNode _pageFocus = FocusNode(debugLabel: 'reader-page');
  final FocusNode _jumpFocus = FocusNode(debugLabel: 'jump-field');
  Future<_LoadedSurah>? _load;
  bool _loadRequested = false;
  int? _pendingScroll;
  String? _jumpError;
  int _verseCount = 0;

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
    _pageFocus.dispose();
    _jumpFocus.dispose();
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
      // Revisiting: keep the saved verse and reveal it (once laid out —
      // the list is not attached on the first build, so retry below).
      setState(() => _pendingScroll = current!.key.ayahNumber);
      _pokeScroll();
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
    // List index 0 is a spacer, so verse N lives at index N.
    setState(() => _pendingScroll = ayah);
    _pokeScroll();
  }

  /// Rebuild until the list attaches so the build-branch scroll fires.
  /// Bounded: gives up silently after ~60 frames (verse stays reachable
  /// by manual scroll).
  void _pokeScroll([int attempt = 0]) {
    if (!mounted || _pendingScroll == null || attempt > 60) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _pendingScroll == null) {
        return;
      }
      if (_scroll.isAttached) {
        setState(() {});
      } else {
        _pokeScroll(attempt + 1);
      }
    });
  }

  /// Keyboard step: move the reading position by [delta] within this surah.
  Future<void> _moveBy(int delta) async {
    if (_verseCount < 1 || !mounted) {
      return;
    }
    final ReadingProgressRepository progress = ref.read(
      readingProgressRepositoryProvider,
    );
    final ReadingPosition? current = await RestoreLastRead(progress)();
    if (!mounted) {
      return;
    }
    final int base = current?.key.surahNumber == widget.surahNumber
        ? current!.key.ayahNumber
        : (delta > 0 ? 0 : _verseCount + 1);
    final int target = (base + delta).clamp(1, _verseCount);
    await UpdateLastRead(progress)(
      AyahKey(surahNumber: widget.surahNumber, ayahNumber: target),
    );
    if (!mounted) {
      return;
    }
    ref.invalidate(lastReadProvider);
    _reveal(target);
  }

  /// Keyboard jump to the first or last verse.
  Future<void> _moveEdge(bool first) async {
    if (_verseCount < 1 || !mounted) {
      return;
    }
    final ReadingProgressRepository progress = ref.read(
      readingProgressRepositoryProvider,
    );
    final int target = first ? 1 : _verseCount;
    await UpdateLastRead(progress)(
      AyahKey(surahNumber: widget.surahNumber, ayahNumber: target),
    );
    if (!mounted) {
      return;
    }
    ref.invalidate(lastReadProvider);
    _reveal(target);
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
        _verseCount = loaded.surah.verseCount;
        final bool compact =
            ref.watch(densitySettingProvider) ==
            PreferencesRepository.densityCompact;
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
        return Scaffold(
          appBar: _ReaderBar(surah: loaded.surah),
          body: Shortcuts(
            // NOTE: not const — SingleActivator has identity equality, so
            // distinct instances must be runtime map keys.
            shortcuts: <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.arrowDown): _MoveAyahIntent(1),
              SingleActivator(LogicalKeyboardKey.arrowUp): _MoveAyahIntent(-1),
              SingleActivator(LogicalKeyboardKey.keyJ): _MoveAyahIntent(1),
              SingleActivator(LogicalKeyboardKey.keyK): _MoveAyahIntent(-1),
              SingleActivator(LogicalKeyboardKey.home): _EdgeAyahIntent(true),
              SingleActivator(LogicalKeyboardKey.end): _EdgeAyahIntent(false),
              SingleActivator(LogicalKeyboardKey.slash): _FocusJumpIntent(),
              SingleActivator(LogicalKeyboardKey.escape): _BackToIndexIntent(),
              SingleActivator(LogicalKeyboardKey.f1): _ShowShortcutsIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                _MoveAyahIntent: CallbackAction<_MoveAyahIntent>(
                  onInvoke: (_MoveAyahIntent intent) => _moveBy(intent.delta),
                ),
                _EdgeAyahIntent: CallbackAction<_EdgeAyahIntent>(
                  onInvoke: (_EdgeAyahIntent intent) => _moveEdge(intent.first),
                ),
                _FocusJumpIntent: CallbackAction<_FocusJumpIntent>(
                  onInvoke: (_FocusJumpIntent intent) {
                    _jumpFocus.requestFocus();
                    return null;
                  },
                ),
                _BackToIndexIntent: CallbackAction<_BackToIndexIntent>(
                  onInvoke: (_BackToIndexIntent intent) {
                    context.go(AppRoutes.surahs);
                    return null;
                  },
                ),
                _ShowShortcutsIntent: CallbackAction<_ShowShortcutsIntent>(
                  onInvoke: (_ShowShortcutsIntent intent) {
                    showDialog(
                      context: context,
                      builder: (context) => const _ShortcutsDialog(),
                    );
                    return null;
                  },
                ),
              },
              child: Focus(
                autofocus: true,
                focusNode: _pageFocus,
                child: Column(
                  children: [
                    _SurahHeader(
                      surah: loaded.surah,
                      jumpField: _jumpField,
                      jumpFocus: _jumpFocus,
                      jumpError: _jumpError,
                      onJump: (raw) => _jumpTo(raw, loaded.surah.verseCount),
                    ),
                    Expanded(
                      child: Center(
                        // Readable line length on wide desktop windows.
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: Column(
                            children: [
                              _ReadingProgressStrip(
                                positions: _positions,
                                verseCount: loaded.verses.length,
                              ),
                              Expanded(
                                child: ScrollablePositionedList.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  itemCount: loaded.verses.length + 1,
                                  itemScrollController: _scroll,
                                  itemPositionsListener: _positions,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return const SizedBox(height: 8);
                                    }
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (index > 1)
                                          Divider(
                                            height: compact ? 12 : 24,
                                            thickness: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outlineVariant
                                                .withValues(alpha: 0.5),
                                          ),
                                        _VerseCard(
                                          content: content,
                                          verse: loaded.verses[index - 1],
                                          totalVerses: loaded.verses.length,
                                          compact: compact,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _SurahFooter(previous: loaded.previous, next: loaded.next),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReaderBar extends ConsumerWidget implements PreferredSizeWidget {
  const _ReaderBar({required this.surah});

  final Surah surah;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double size = ref.watch(arabicFontSizeSettingProvider);
    return AppBar(
      leading: IconButton(
        tooltip: 'Back to index',
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go(AppRoutes.surahs),
      ),
      title: Text(surah.latinName),
      centerTitle: false,
      actions: [
        IconButton(
          tooltip: 'Decrease Arabic size',
          icon: const Text('A−', style: TextStyle(fontWeight: FontWeight.w700)),
          onPressed: () => ref
              .read(arabicFontSizeSettingProvider.notifier)
              .set(size - AppTypography.arabicVerseStep),
        ),
        IconButton(
          tooltip: 'Increase Arabic size',
          icon: const Text('A+', style: TextStyle(fontWeight: FontWeight.w700)),
          onPressed: () => ref
              .read(arabicFontSizeSettingProvider.notifier)
              .set(size + AppTypography.arabicVerseStep),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _ShortcutsDialog extends StatelessWidget {
  const _ShortcutsDialog();

  static const List<(String, String)> _rows = [
    ('↓ / J', 'Next ayah'),
    ('↑ / K', 'Previous ayah'),
    ('Home / End', 'First / last ayah'),
    ('/', 'Go to the ayah field'),
    ('F1', 'This list'),
    ('Esc', 'Back to the index'),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reader shortcuts'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (String keys, String action) in _rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      keys,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(child: Text(action)),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ReadingProgressStrip extends StatelessWidget {
  const _ReadingProgressStrip({
    required this.positions,
    required this.verseCount,
  });

  final ItemPositionsListener positions;
  final int verseCount;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<Iterable<ItemPosition>>(
      valueListenable: positions.itemPositions,
      builder: (context, value, _) {
        int current = 1;
        for (final ItemPosition position in value) {
          if (position.index > 0 &&
              position.itemLeadingEdge < 0.9 &&
              position.index < current + verseCount) {
            if (current == 1 || position.index < current) {
              current = position.index;
            }
          }
        }
        current = current.clamp(1, verseCount);
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 2),
          child: Row(
            children: [
              Text(
                'Ayah $current of $verseCount',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LinearProgressIndicator(
                  value: verseCount <= 1 ? 1 : current / verseCount,
                  backgroundColor: scheme.surfaceContainerHighest,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SurahHeader extends ConsumerWidget {
  const _SurahHeader({
    required this.surah,
    required this.jumpField,
    required this.jumpFocus,
    required this.jumpError,
    required this.onJump,
  });

  final Surah surah;
  final TextEditingController jumpField;
  final FocusNode jumpFocus;
  final String? jumpError;
  final void Function(String raw) onJump;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color gold = theme.brightness == Brightness.dark
        ? AppColors.darkGold
        : AppColors.gold;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        border: Border(bottom: BorderSide(color: scheme.outline)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    revelationLabel(surah.revelationType) ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: CartouchePlate(
                    color: gold,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 56,
                      vertical: 9,
                    ),
                    child: Text(
                      surah.arabicName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTypography.arabicFontFamily,
                        fontSize: 28,
                        height: 1.4,
                        color: gold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${surah.verseCount} Ayat',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _ProgressRow(surah: surah),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: jumpField,
                  focusNode: jumpFocus,
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

class _ProgressRow extends ConsumerWidget {
  const _ProgressRow({required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final ReadingPosition? lastRead = ref
        .watch(lastReadProvider)
        .maybeWhen(data: (position) => position, orElse: () => null);
    final int read = lastRead?.key.surahNumber == surah.number
        ? lastRead!.key.ayahNumber
        : 0;
    final double progress = surah.verseCount <= 0
        ? 0
        : (read / surah.verseCount).clamp(0.0, 1.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            color: scheme.primary,
            backgroundColor: scheme.primary.withValues(alpha: 0.15),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          read == 0
              ? '${surah.latinName} · ${surah.verseCount} verses'
              : '${surah.latinName} · ayah $read of ${surah.verseCount} '
                    '(${(progress * 100).round()}%)',
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onPrimaryContainer,
          ),
        ),
      ],
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
        children: [
          if (previous != null)
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go(AppRoutes.reader(previous!.number)),
                child: Text('‹ ${previous!.latinName}'),
              ),
            ),
          if (previous != null && next != null) const SizedBox(width: 12),
          if (next != null)
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go(AppRoutes.reader(next!.number)),
                child: Text('${next!.latinName} ›'),
              ),
            ),
        ],
      ),
    );
  }
}

class _VerseCard extends ConsumerWidget {
  const _VerseCard({
    required this.content,
    required this.verse,
    required this.totalVerses,
    required this.compact,
  });

  final QuranContentRepository content;
  final Ayah verse;
  final int totalVerses;

  /// Compact density from Settings (smaller padding, tighter line height).
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color gold = theme.brightness == Brightness.dark
        ? AppColors.darkGold
        : AppColors.gold;
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
    // Display-only split: the stored text stays verbatim (see basmalah.dart).
    final DisplayVerse display = splitBasmalahForDisplay(
      surah: verse.key.surahNumber,
      ayah: verse.key.ayahNumber,
      arabicText: verse.arabicText,
    );

    return Semantics(
      // Screen readers announce position and current-position state;
      // highlight is never color-only.
      label:
          'Ayah ${verse.key.ayahNumber} of $totalVerses'
          '${highlighted ? ', current position' : ''}'
          '${isBookmarked ? ', bookmarked' : ''}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(compact ? 8 : 12),
        decoration: highlighted
            ? BoxDecoration(
                color: scheme.primaryContainer,
                border: Border(
                  left: BorderSide(color: scheme.primary, width: 3),
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ornamental ayah-number medallion sits at the head of the
                // verse line, matching Indonesian mushaf printings.
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: VerseMedallion(number: verse.key.ayahNumber),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (display.basmalah != null) ...[
                        Text(
                          display.basmalah!,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTypography.arabicFontFamily,
                            fontSize: arabicSize + 2,
                            height: compact ? 1.8 : 2.0,
                            color: gold,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text.rich(
                        TextSpan(children: [TextSpan(text: display.arabic)]),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppTypography.arabicFontFamily,
                          fontSize: arabicSize,
                          height: compact ? 1.8 : 2.0,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: ValueKey(
                        'bookmark-${verse.key.surahNumber}-${verse.key.ayahNumber}',
                      ),
                      tooltip: isBookmarked
                          ? 'Remove bookmark'
                          : 'Bookmark this verse',
                      visualDensity: VisualDensity.compact,
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
                    IconButton(
                      tooltip: 'Copy verse text',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () async {
                        // Verbatim copy of the stored text (no marker).
                        await Clipboard.setData(
                          ClipboardData(text: verse.arabicText),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Ayah ${verse.key.ayahNumber} copied',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
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
      ),
    );
  }
}
