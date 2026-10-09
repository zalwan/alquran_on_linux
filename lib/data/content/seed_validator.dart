import 'seed_bundle.dart';

/// Structural validation per `docs/data-sources.md` §3.1: completeness,
/// identifiers, ordering, encoding presence, translation mapping.
///
/// Returns human-readable errors; empty means the bundle may be seeded.
/// This is structural validation only — never a claim of scholarly review.
List<String> validateSeedBundle(
  SeedBundle bundle, {
  required int expectedSurahCount,
}) {
  final List<String> errors = [];

  // --- Surah list ---------------------------------------------------------
  final Set<int> numbers = {};
  for (final SeedSurah surah in bundle.surahs) {
    if (surah.number < 1 || surah.number > 114) {
      errors.add('Surah number out of range: ${surah.number}.');
    }
    if (!numbers.add(surah.number)) {
      errors.add('Duplicate surah: ${surah.number}.');
    }
    if (surah.arabicName.isEmpty || surah.latinName.isEmpty) {
      errors.add('Surah ${surah.number} has an empty name.');
    }
    if (surah.verseCount < 1) {
      errors.add('Surah ${surah.number} has no verses.');
    }
  }
  if (bundle.surahs.length != expectedSurahCount) {
    errors.add(
      'Expected $expectedSurahCount surahs, found ${bundle.surahs.length}.',
    );
  }
  final List<int> sorted = numbers.toList()..sort();
  for (int i = 0; i < sorted.length; i++) {
    if (sorted[i] != i + 1) {
      errors.add(
        'Surah numbering is not gapless from 1 '
        '(first break at position ${i + 1}).',
      );
      break;
    }
  }

  // --- Verses ---------------------------------------------------------------
  final Map<int, List<int>> ayahsBySurah = {};
  final Set<String> verseKeys = {};
  for (final SeedVerse verse in bundle.verses) {
    final String key = '${verse.surah}:${verse.ayah}';
    if (!verseKeys.add(key)) {
      errors.add('Duplicate verse: $key.');
    }
    if (!numbers.contains(verse.surah)) {
      errors.add('Verse $key belongs to unknown surah ${verse.surah}.');
    }
    if (verse.ayah < 1) {
      errors.add('Verse $key has an invalid ayah number.');
    }
    if (verse.arabic.isEmpty) {
      errors.add('Verse $key has empty text.');
    }
    ayahsBySurah.putIfAbsent(verse.surah, () => []).add(verse.ayah);
  }
  for (final SeedSurah surah in bundle.surahs) {
    final List<int> ayahs = (ayahsBySurah[surah.number] ?? [])..sort();
    bool matches = ayahs.length == surah.verseCount;
    for (int i = 0; matches && i < ayahs.length; i++) {
      matches = ayahs[i] == i + 1;
    }
    if (!matches) {
      errors.add(
        'Surah ${surah.number}: expected ayahs 1..${surah.verseCount}, '
        'found ${ayahs.length} rows.',
      );
    }
  }

  // --- Translations ---------------------------------------------------------
  if (bundle.translationEditionId.isEmpty) {
    errors.add('Translation edition id is empty.');
  }
  final Set<String> translationKeys = {};
  for (final SeedTranslationRow row in bundle.translations) {
    final String key = '${row.surah}:${row.ayah}:${row.editionId}';
    if (!translationKeys.add(key)) {
      errors.add('Duplicate translation row: $key.');
    }
    if (row.editionId != bundle.translationEditionId) {
      errors.add(
        'Translation row $key belongs to unexpected edition '
        '${row.editionId}.',
      );
    }
    if (!verseKeys.contains('${row.surah}:${row.ayah}')) {
      errors.add(
        'Orphan translation row: ${row.surah}:${row.ayah} '
        'has no matching verse.',
      );
    }
    if (row.text.isEmpty) {
      errors.add('Translation row ${row.surah}:${row.ayah} has empty text.');
    }
  }

  return errors;
}
