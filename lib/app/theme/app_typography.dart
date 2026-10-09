/// Typographic scale from `docs/theme.md` §6.
///
/// The final font family is decided by the Phase 0 font ADR; this file only
/// fixes roles and numeric bounds. Arabic sizes are user-adjustable and the
/// reader must clamp to [arabicVerseMin]–[arabicVerseMax].
abstract final class AppTypography {
  /// Bundled Arabic verse typeface (Amiri, SIL OFL 1.1 — see ADR-0002 and
  /// the spike report). Applied to verse text and Arabic names only; the
  /// Latin UI keeps the platform default.
  static const String arabicFontFamily = 'Amiri';

  static const double arabicVerseMin = 20;
  static const double arabicVerseMax = 40;
  static const double arabicVerseStep = 2;
  static const double arabicVerseDefault = 28;

  /// Generous line height so harakat and stacked marks never clip.
  static const double arabicLineHeight = 2.0;

  static const double translationSize = 16;
  static const double translationLineHeight = 1.6;

  static const double surahNameSize = 17;
  static const double metadataSize = 13;

  static double clampArabicSize(double value) =>
      value.clamp(arabicVerseMin, arabicVerseMax);
}
