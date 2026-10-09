import 'package:alquran_on_linux/data/content/seed_bundle.dart';
import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:alquran_on_linux/domain/entities/content_manifest.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Synthetic bundles: structurally valid, ASCII `PLACEHOLDER` markers only —
/// obviously not real content. Shared by seed and widget tests.
SeedBundle syntheticBundle({bool withTranslation = true}) {
  SeedSurah surah(int n) => SeedSurah(
    number: n,
    arabicName: 'سورة $n',
    latinName: 'Surah $n',
    verseCount: 3,
  );
  return SeedBundle(
    surahs: [surah(1), surah(2), surah(3)],
    verses: [
      for (int s = 1; s <= 3; s++)
        for (int a = 1; a <= 3; a++)
          SeedVerse(surah: s, ayah: a, arabic: 'PLACEHOLDER $s:$a'),
    ],
    translations: [
      if (withTranslation)
        for (int s = 1; s <= 3; s++)
          for (int a = 1; a <= 3; a++)
            SeedTranslationRow(
              surah: s,
              ayah: a,
              editionId: 'synthetic-id',
              text: 'TRANSLATION $s:$a',
            ),
    ],
    translationEditionId: withTranslation ? 'synthetic-id' : null,
  );
}

ContentManifest syntheticManifest({bool withTranslation = true}) =>
    ContentManifest(
      arabicSource: 'synthetic',
      arabicEdition: 'synthetic-1',
      arabicSha256: 'synthetic',
      translationEditionId: withTranslation ? 'synthetic-id' : null,
      translationVersion: withTranslation ? 'synthetic-1' : null,
      translationSha256: withTranslation ? 'synthetic' : null,
      acquiredAt: DateTime.utc(2026, 10, 9),
      validationReportRef: 'synthetic-report',
    );

AppDatabase memoryDb() {
  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  return db;
}
