import 'dart:convert';

import 'package:flutter/services.dart';

import '../database/app_database.dart';
import '../repositories/drift_content_repository.dart';
import 'content_seeder.dart';
import 'tanzil_parser.dart';
import '../../domain/entities/content_manifest.dart';

/// True when seeded surah rows predate the revelation-type column.
Future<bool> _missingRevelationTypes(AppDatabase db) async {
  final List<SurahRow> rows = await (db.select(
    db.surahs,
  )..where((t) => t.revelationType.isNull())).get();
  return rows.isNotEmpty;
}

/// First-launch content bootstrap for the v1.0 Arabic-only dataset.
///
/// Reads the committed, checksummed files from `data/manifest/`, validates,
/// and seeds. Returns true when seeding ran, false when content was already
/// present. Throws on invalid files — callers decide how to degrade (the
/// app launches unseeded and screens show their pending states).
Future<bool> ensureContentSeeded(AppDatabase db, AssetBundle assets) async {
  final DriftQuranContentRepository repo = DriftQuranContentRepository(db);
  bool needsSeed = false;
  try {
    await repo.getManifest();
    // Seeded by an older app version without revelation types (schema v1
    // rows): reseed from the bundled files to fill them. User tables are
    // untouched by seeding.
    needsSeed = await _missingRevelationTypes(db);
  } on StateError {
    // Not seeded yet — fall through.
    needsSeed = true;
  }
  if (!needsSeed) {
    return false;
  }
  final String text = await assets.loadString(
    'data/manifest/tanzil-uthmani-v1.1.txt',
  );
  final String metadata = await assets.loadString(
    'data/manifest/quran-data-v1.0.xml',
  );
  final Map<String, Object?> manifestJson =
      jsonDecode(await assets.loadString('data/manifest/manifest.json'))
          as Map<String, Object?>;
  final ContentManifest manifest = ContentManifest.fromJson(manifestJson);
  final bundle = parseTanzilBundle(text, metadata);
  await seedContent(db, bundle, manifest, expectedSurahCount: 114);
  return true;
}
