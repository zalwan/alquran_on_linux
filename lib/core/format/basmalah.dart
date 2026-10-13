import '../../domain/entities/ayah.dart';

/// Display-only basmalah separation for verse 1.
///
/// The approved Tanzil text carries the basmalah inline at the start of
/// verse 1 in every surah except Al-Fatihah (where verse 1 IS the basmalah)
/// and At-Taubah (no basmalah). Two Uthmani spellings exist in the file:
/// the standard form (111 surahs) and a ba-with-shadda form in At-Tin (95)
/// and Al-Qadr (97) — both verified byte-for-byte against
/// `data/manifest/tanzil-uthmani-v1.1.txt` (see `test/unit/basmalah_test`
/// 'matches every verse 1 in the committed text').
///
/// ASCII escapes keep invisible combining marks reviewable. This splitter
/// NEVER modifies stored text: it only decides presentation. Unknown shapes
/// fall back to joined display — never an error, never a rewrite. Data
/// change upstream fails the real-data test loudly instead of silently
/// reshaping verses.
class DisplayVerse {
  const DisplayVerse({
    required this.key,
    required this.arabic,
    required this.basmalah,
  });

  final AyahKey key;

  /// Verse text to render (remainder after the basmalah, or the full
  /// verbatim text when there is nothing to split).
  final String arabic;

  /// Basmalah line to render centered above [arabic], or null.
  final String? basmalah;
}

/// Standard basmalah: Al-Fatihah 1:1 and 111 other surahs.
const String basmalahStandard =
    '\u0628\u0650\u0633\u0652\u0645\u0650\u0020\u0671\u0644\u0644\u0651\u064E\u0647\u0650\u0020\u0671\u0644\u0631\u0651\u064E\u062D\u0652\u0645\u064E\u0640\u0670\u0646\u0650\u0020\u0671\u0644\u0631\u0651\u064E\u062D\u0650\u064A\u0645\u0650';

/// Ba-with-shadda basmalah: At-Tin (95) and Al-Qadr (97) only.
const String basmalahShadda =
    '\u0628\u0651\u0650\u0633\u0652\u0645\u0650\u0020\u0671\u0644\u0644\u0651\u064E\u0647\u0650\u0020\u0671\u0644\u0631\u0651\u064E\u062D\u0652\u0645\u064E\u0640\u0670\u0646\u0650\u0020\u0671\u0644\u0631\u0651\u064E\u062D\u0650\u064A\u0645\u0650';

const List<String> basmalahForms = [basmalahStandard, basmalahShadda];

DisplayVerse splitBasmalahForDisplay({
  required int surah,
  required int ayah,
  required String arabicText,
}) {
  DisplayVerse asIs() => DisplayVerse(
    key: AyahKey(surahNumber: surah, ayahNumber: ayah),
    arabic: arabicText,
    basmalah: null,
  );

  // Only verse 1 can carry a basmalah; At-Taubah has none.
  if (ayah != 1 || surah == 9) {
    return asIs();
  }
  for (final String form in basmalahForms) {
    if (arabicText == form) {
      // The whole verse IS the basmalah (Al-Fatihah 1:1): render as-is.
      return asIs();
    }
    if (arabicText.startsWith('$form ')) {
      return DisplayVerse(
        key: AyahKey(surahNumber: surah, ayahNumber: ayah),
        arabic: arabicText.substring(form.length + 1),
        basmalah: form,
      );
    }
  }
  return asIs();
}
