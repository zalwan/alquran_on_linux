/// A surah of the approved dataset: stable number, names, and verse count.
class Surah {
  Surah({
    required this.number,
    required this.arabicName,
    required this.latinName,
    required this.verseCount,
    this.revelationType,
  }) {
    RangeError.checkValueInInterval(number, 1, 114, 'number');
    if (arabicName.isEmpty || latinName.isEmpty) {
      throw ArgumentError('Surah names must not be empty.');
    }
    if (verseCount < 1) {
      throw ArgumentError.value(verseCount, 'verseCount', 'Must be >= 1.');
    }
    if (revelationType != null &&
        revelationType != 'Meccan' &&
        revelationType != 'Medinan') {
      throw ArgumentError.value(
        revelationType,
        'revelationType',
        "Must be 'Meccan' or 'Medinan'.",
      );
    }
  }

  final int number;
  final String arabicName;
  final String latinName;
  final int verseCount;

  /// 'Meccan' or 'Medinan' from the approved metadata, or null when the
  /// seeding source did not carry it.
  final String? revelationType;
}
