/// Parsed, pre-database representation of one approved content set.
///
/// The production bundle is built from the cleared Tanzil + QuranEnc files
/// (see `docs/translation-clearance.md`). Tests build synthetic bundles
/// with obviously-fake `PLACEHOLDER` strings — never real verses.
class SeedSurah {
  const SeedSurah({
    required this.number,
    required this.arabicName,
    required this.latinName,
    required this.verseCount,
  });

  final int number;
  final String arabicName;
  final String latinName;
  final int verseCount;
}

class SeedVerse {
  const SeedVerse({
    required this.surah,
    required this.ayah,
    required this.arabic,
  });

  final int surah;
  final int ayah;
  final String arabic;
}

class SeedTranslationRow {
  const SeedTranslationRow({
    required this.surah,
    required this.ayah,
    required this.editionId,
    required this.text,
  });

  final int surah;
  final int ayah;
  final String editionId;
  final String text;
}

class SeedBundle {
  const SeedBundle({
    required this.surahs,
    required this.verses,
    required this.translations,
    required this.translationEditionId,
  });

  final List<SeedSurah> surahs;
  final List<SeedVerse> verses;
  final List<SeedTranslationRow> translations;

  /// The single edition every translation row must belong to.
  final String translationEditionId;
}
