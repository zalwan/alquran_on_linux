/// Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩) for verse-end markers (۝).
///
/// Pure Dart. The digits render inside the ۝ medallion in all bundled
/// Arabic fonts (proven by the rendering spike goldens).
String arabicIndic(int value) {
  if (value < 0) {
    throw ArgumentError.value(value, 'value', 'Must not be negative.');
  }
  const List<String> digits = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];
  return value
      .toString()
      .split('')
      .map((String d) => digits[int.parse(d)])
      .join();
}

/// A traditional verse-end marker: `۝١٢٣`.
String ayahMarker(int ayahNumber) => ' \u06DD${arabicIndic(ayahNumber)}';
