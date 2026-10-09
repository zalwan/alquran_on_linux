/// A surah of the approved dataset: stable number, names, and verse count.
class Surah {
  Surah({
    required this.number,
    required this.arabicName,
    required this.latinName,
    required this.verseCount,
  }) {
    RangeError.checkValueInInterval(number, 1, 114, 'number');
    if (arabicName.isEmpty || latinName.isEmpty) {
      throw ArgumentError('Surah names must not be empty.');
    }
    if (verseCount < 1) {
      throw ArgumentError.value(verseCount, 'verseCount', 'Must be >= 1.');
    }
  }

  final int number;
  final String arabicName;
  final String latinName;
  final int verseCount;
}
