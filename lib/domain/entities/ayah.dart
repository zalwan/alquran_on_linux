/// Stable identifier for a single verse: `(surahNumber, ayahNumber)`.
///
/// Pure Dart — no Flutter, database, or platform imports allowed in this
/// layer (see `architecture.md` §2).
class AyahKey {
  const AyahKey({required this.surahNumber, required this.ayahNumber});

  final int surahNumber;
  final int ayahNumber;

  /// Validates the MVP identifier rules shared by every repository.
  static void checkValid(int surahNumber, int ayahNumber) {
    RangeError.checkValueInInterval(surahNumber, 1, 114, 'surahNumber');
    if (ayahNumber < 1) {
      throw ArgumentError.value(ayahNumber, 'ayahNumber', 'Must be >= 1.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahKey &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber);

  @override
  String toString() => '$surahNumber:$ayahNumber';
}

/// One verse of the approved Arabic text.
///
/// The text must be stored and returned **verbatim**: repositories and use
/// cases must never normalize, rewrite, or auto-translate it
/// (`PRD.md` §7.7, `architecture.md` §1.8).
class Ayah {
  Ayah({required this.key, required String arabicText})
    : arabicText = arabicText {
    AyahKey.checkValid(key.surahNumber, key.ayahNumber);
    if (arabicText.isEmpty) {
      throw ArgumentError.value(arabicText, 'arabicText', 'Must not be empty.');
    }
  }

  final AyahKey key;
  final String arabicText;
}
