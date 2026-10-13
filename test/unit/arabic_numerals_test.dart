import 'package:flutter_test/flutter_test.dart';

import 'package:alquran_on_linux/core/format/arabic_numerals.dart';

void main() {
  test('converts 1-114 to arabic-indic digits', () {
    expect(arabicIndic(1), '١');
    expect(arabicIndic(7), '٧');
    expect(arabicIndic(10), '١٠');
    expect(arabicIndic(114), '١١٤');
    expect(arabicIndic(286), '٢٨٦');
  });

  test('builds verse-end markers', () {
    expect(ayahMarker(2), ' \u06DD٢');
  });

  test('rejects negative input', () {
    expect(() => arabicIndic(-1), throwsArgumentError);
  });
}
