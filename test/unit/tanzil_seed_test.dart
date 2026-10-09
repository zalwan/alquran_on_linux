import 'dart:convert';
import 'dart:io';

import 'package:alquran_on_linux/data/content/content_seeder.dart';
import 'package:alquran_on_linux/data/content/tanzil_parser.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/data/repositories/drift_content_repository.dart';
import 'package:alquran_on_linux/domain/entities/ayah.dart';
import 'package:alquran_on_linux/domain/entities/content_manifest.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Validates the EXACT committed v1.0 files (`data/manifest/`): hashes match
/// `manifest.json`, parsing + structural validation pass for 114 surahs,
/// and the bundle seeds and serves. This is the automated half of the
/// validation report it references.
void main() {
  const String dir = 'data/manifest';

  String sha256Of(String path) =>
      sha256.convert(File(path).readAsBytesSync()).toString();

  test('manifest hashes match the committed files', () {
    final Map<String, Object?> manifestJson =
        jsonDecode(File('$dir/manifest.json').readAsStringSync())
            as Map<String, Object?>;
    expect(
      sha256Of('$dir/tanzil-uthmani-v1.1.txt'),
      manifestJson['arabicSha256'],
    );
    expect(
      sha256Of('$dir/quran-data-v1.0.xml'),
      manifestJson['metadataSha256'],
    );
    final ContentManifest manifest = ContentManifest.fromJson(manifestJson);
    expect(manifest.hasTranslation, isFalse);
    expect(manifest.validationReportRef, isNotEmpty);
  });

  test('committed bundle seeds 114 surahs and serves in order', () async {
    final String text = File('$dir/tanzil-uthmani-v1.1.txt').readAsStringSync();
    final String metadata = File('$dir/quran-data-v1.0.xml').readAsStringSync();
    final ContentManifest manifest = ContentManifest.fromJson(
      jsonDecode(File('$dir/manifest.json').readAsStringSync())
          as Map<String, Object?>,
    );

    final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = DriftQuranContentRepository(db);

    await seedContent(
      db,
      parseTanzilBundle(text, metadata),
      manifest,
      expectedSurahCount: 114,
    );

    final surahs = await repo.getSurahs();
    expect(surahs.map((s) => s.number), List.generate(114, (i) => i + 1));
    expect(surahs.first.verseCount, 7);
    expect(surahs.first.arabicName, isNotEmpty);
    expect(surahs.first.latinName, isNotEmpty);

    int total = 0;
    for (final surah in surahs) {
      final verses = await repo.getAyahs(surah.number);
      expect(
        verses.map((v) => v.key.ayahNumber),
        List.generate(surah.verseCount, (i) => i + 1),
      );
      total += verses.length;
    }
    expect(total, 6236);

    // Spot checks: first and last keys resolve with non-empty verbatim text.
    final Ayah first = (await repo.getAyahs(
      1,
    )).firstWhere((v) => v.key.ayahNumber == 1);
    expect(first.arabicText.trim(), isNotEmpty);
    final Ayah last = (await repo.getAyahs(114)).last;
    expect(last.key, const AyahKey(surahNumber: 114, ayahNumber: 6));
    expect(last.arabicText.trim(), isNotEmpty);

    expect((await repo.getManifest()).arabicEdition, manifest.arabicEdition);
  });

  test('parser rejects corrupt input loudly', () {
    expect(
      () => parseTanzilBundle('not|valid', '<quran/>'),
      throwsFormatException,
    );
    expect(
      () => parseTanzilBundle('1|1|ok', '<quran></quran>'),
      returnsNormally,
      reason: 'metadata without suras parses; validator catches the gap',
    );
  });
}
