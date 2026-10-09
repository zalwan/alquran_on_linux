import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const String _spikeDir = 'spikes/arabic-rendering';
const String _samplePath = '$_spikeDir/samples/fatihah-uthmani.txt';

const Map<String, String> _fonts = {
  'AmiriSpike': '$_spikeDir/fonts/Amiri-Regular.ttf',
  'ScheherazadeSpike': '$_spikeDir/fonts/ScheherazadeNew-Regular.ttf',
  'NotoSpike': '$_spikeDir/fonts/NotoNaskhArabic[wght].ttf',
};

const Map<String, String> _goldens = {
  'AmiriSpike': 'goldens/arabic_amiri.png',
  'ScheherazadeSpike': 'goldens/arabic_scheherazade.png',
  'NotoSpike': 'goldens/arabic_noto.png',
};

String _arabicIndic(int n) {
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
  return n.toString().split('').map((String d) => digits[int.parse(d)]).join();
}

Future<void> _loadFont(String family, String path) async {
  final Uint8List bytes = await File(path).readAsBytes();
  final FontLoader loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

/// Parses `sura|aya|text` lines verbatim — no normalization of any kind.
List<(int aya, String text)> _loadSample() {
  final List<String> lines = File(_samplePath).readAsLinesSync();
  return [
    for (final String line in lines)
      if (line.trim().isNotEmpty)
        (int.parse(line.split('|')[1]), line.split('|').sublist(2).join('|')),
  ];
}

Widget _verseBlock(
  String family,
  (int, String) verse,
  double size, {
  bool showMarker = true,
}) {
  final (int aya, String text) = verse;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text),
          if (showMarker) TextSpan(text: ' \u06DD${_arabicIndic(aya)}'),
        ],
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: family,
        fontSize: size,
        height: 2.0,
        color: Colors.black,
      ),
    ),
  );
}

Widget _spikeScreen(String family, List<(int, String)> verses, double size) {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // LTR control row: Latin labels must not disturb RTL verses.
            // Uses the same spike family (all three candidates ship Latin
            // glyphs) so the test env's default block font never interferes.
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Spike · Al-Fatihah · 7 verses · Uthmani sample',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontFamily: family),
                ),
              ),
            ),
            for (final verse in verses) _verseBlock(family, verse, size),
          ],
        ),
      ),
    ),
  );
}

void main() {
  final List<(int, String)> verses = _loadSample();

  test('sample fixture is intact: 7 verbatim verses', () {
    expect(verses, hasLength(7));
    expect(verses.map((v) => v.$1).toList(), [1, 2, 3, 4, 5, 6, 7]);
    for (final verse in verses) {
      expect(verse.$2.trim(), isNotEmpty);
    }
  });

  for (final MapEntry<String, String> font in _fonts.entries) {
    group(font.key, () {
      setUpAll(() => _loadFont(font.key, font.value));

      testWidgets('lays out at 20/28/40sp without overflow', (tester) async {
        tester.view.physicalSize = const ui.Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        for (final double size in [20.0, 28.0, 40.0]) {
          await tester.pumpWidget(_spikeScreen(font.key, verses, size));
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${font.key} overflowed at ${size}sp',
          );
        }
      });

      testWidgets('golden reference at 28sp', (tester) async {
        tester.view.physicalSize = const ui.Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(_spikeScreen(font.key, verses, 28));
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile(_goldens[font.key]!),
        );
      });
    });
  }
}
