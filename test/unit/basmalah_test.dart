import 'dart:io';

import 'package:alquran_on_linux/core/format/basmalah.dart';
import 'package:flutter_test/flutter_test.dart';

/// Rules first (synthetic strings), then the ground truth: every verse 1
/// in the committed Tanzil file.
void main() {
  group('split rules', () {
    test('non-first verses never split', () {
      final DisplayVerse out = splitBasmalahForDisplay(
        surah: 2,
        ayah: 2,
        arabicText: '$basmalahStandard extra',
      );
      expect(out.basmalah, isNull);
      expect(out.arabic, '$basmalahStandard extra');
    });

    test('surah 9 never splits', () {
      final DisplayVerse out = splitBasmalahForDisplay(
        surah: 9,
        ayah: 1,
        arabicText: '$basmalahStandard extra',
      );
      expect(out.basmalah, isNull);
    });

    test('whole-basmalah verse stays joined (Al-Fatihah 1:1)', () {
      final DisplayVerse out = splitBasmalahForDisplay(
        surah: 1,
        ayah: 1,
        arabicText: basmalahStandard,
      );
      expect(out.basmalah, isNull);
      expect(out.arabic, basmalahStandard);
    });

    test('standard prefix splits, remainder preserved verbatim', () {
      const String rest = 'remainder-text';
      final DisplayVerse out = splitBasmalahForDisplay(
        surah: 2,
        ayah: 1,
        arabicText: '$basmalahStandard $rest',
      );
      expect(out.basmalah, basmalahStandard);
      expect(out.arabic, rest);
      expect(out.key.surahNumber, 2);
    });

    test('shadda form splits too', () {
      final DisplayVerse out = splitBasmalahForDisplay(
        surah: 95,
        ayah: 1,
        arabicText: '$basmalahShadda rest',
      );
      expect(out.basmalah, basmalahShadda);
      expect(out.arabic, 'rest');
    });

    test('unknown shape falls back to joined display', () {
      final DisplayVerse out = splitBasmalahForDisplay(
        surah: 3,
        ayah: 1,
        arabicText: 'something unexpected',
      );
      expect(out.basmalah, isNull);
      expect(out.arabic, 'something unexpected');
    });
  });

  group('against the committed text', () {
    Map<int, String> verse1() {
      final Map<int, String> out = {};
      for (final String line in File(
        'data/manifest/tanzil-uthmani-v1.1.txt',
      ).readAsLinesSync()) {
        if (line.trim().isEmpty || line.startsWith('#')) {
          continue;
        }
        final List<String> parts = line.split('|');
        if (parts[1] == '1') {
          out[int.parse(parts[0])] = parts.sublist(2).join('|');
        }
      }
      return out;
    }

    test('every verse 1 matches a known form (or 9, or whole)', () {
      final Map<int, String> firsts = verse1();
      expect(firsts.length, 114);
      for (int s = 1; s <= 114; s++) {
        final DisplayVerse out = splitBasmalahForDisplay(
          surah: s,
          ayah: 1,
          arabicText: firsts[s]!,
        );
        if (s == 1) {
          expect(out.basmalah, isNull, reason: '1:1 is whole basmalah');
          expect(out.arabic, firsts[s]);
        } else if (s == 9) {
          expect(out.basmalah, isNull, reason: 'At-Taubah has none');
        } else {
          expect(out.basmalah, isNotNull, reason: 'surah $s should split');
          expect(out.arabic, isNotEmpty);
          // Rejoining reproduces the file byte-for-byte.
          expect('${out.basmalah} ${out.arabic}', firsts[s]);
        }
      }
    });
  });
}
