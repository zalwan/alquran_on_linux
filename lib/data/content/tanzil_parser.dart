import 'package:xml/xml.dart';

import 'seed_bundle.dart';

/// Parse the verbatim Tanzil download files into a [SeedBundle].
///
/// - [textFile]: `quranType=uthmani&outType=txt-2` output — `sura|aya|text`
///   lines plus `#` copyright header lines and blanks (skipped, never
///   treated as verses).
/// - [metadataXml]: `quran-data.xml` v1.0 — surah names and verse counts.
///
/// Verse text is carried through byte-for-byte: no trimming of the Arabic,
/// no normalization, no reordering. Throws [FormatException] on any
/// structural surprise so corrupt files fail loudly before seeding.
SeedBundle parseTanzilBundle(String textFile, String metadataXml) {
  final List<SeedVerse> verses = [];
  for (final String line in textFile.split('\n')) {
    if (line.trim().isEmpty || line.startsWith('#')) {
      continue;
    }
    final List<String> parts = line.split('|');
    if (parts.length < 3) {
      throw FormatException(
        'Malformed verse line: ${line.substring(0, line.length > 40 ? 40 : line.length)}',
      );
    }
    final int? surah = int.tryParse(parts[0]);
    final int? ayah = int.tryParse(parts[1]);
    if (surah == null || ayah == null) {
      throw FormatException(
        'Non-numeric identifiers in line: ${parts[0]}|'
        '${parts[1]}',
      );
    }
    verses.add(
      SeedVerse(surah: surah, ayah: ayah, arabic: parts.sublist(2).join('|')),
    );
  }

  final XmlDocument document = XmlDocument.parse(metadataXml);
  final List<SeedSurah> surahs = [];
  for (final XmlElement sura in document.findAllElements('sura')) {
    final int? index = int.tryParse(sura.getAttribute('index') ?? '');
    final int? ayas = int.tryParse(sura.getAttribute('ayas') ?? '');
    final String? name = sura.getAttribute('name');
    final String? tname = sura.getAttribute('tname');
    if (index == null || ayas == null || name == null || tname == null) {
      throw const FormatException('Metadata sura entry missing attributes.');
    }
    surahs.add(
      SeedSurah(
        number: index,
        arabicName: name,
        latinName: tname,
        verseCount: ayas,
      ),
    );
  }

  return SeedBundle(
    surahs: surahs,
    verses: verses,
    translations: const [],
    translationEditionId: null,
  );
}
