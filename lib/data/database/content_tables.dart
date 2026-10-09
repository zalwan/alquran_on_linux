import 'package:drift/drift.dart';

/// Canonical surah list of the approved dataset, in source order.
@DataClassName('SurahRow')
class Surahs extends Table {
  IntColumn get number => integer()();

  TextColumn get arabicName => text()();

  TextColumn get latinName => text()();

  IntColumn get verseCount => integer()();

  @override
  Set<Column> get primaryKey => {number};
}

/// Approved Arabic verses, verbatim. Composite key, ascending ayah order.
@DataClassName('AyahRow')
class Ayahs extends Table {
  IntColumn get surahNumber => integer()();

  IntColumn get ayahNumber => integer()();

  TextColumn get arabicText => text()();

  @override
  Set<Column> get primaryKey => {surahNumber, ayahNumber};
}

/// Approved translation rows. Every row must join an existing verse;
/// orphan rows fail validation before they can be seeded.
@DataClassName('AyahTranslationRow')
class AyahTranslations extends Table {
  IntColumn get surahNumber => integer()();

  IntColumn get ayahNumber => integer()();

  TextColumn get editionId => text()();

  /// Named `translationText` (not `text`) so the getter does not shadow
  /// drift's `text()` column builder.
  TextColumn get translationText => text()();

  @override
  Set<Column> get primaryKey => {surahNumber, ayahNumber, editionId};
}

/// Singleton row (id always 1): provenance of the seeded content set.
/// Seeding without complete manifest fields is rejected upstream.
class ContentMeta extends Table {
  IntColumn get id => integer()();

  TextColumn get arabicSource => text()();

  TextColumn get arabicEdition => text()();

  TextColumn get arabicSha256 => text()();

  TextColumn get translationEditionId => text()();

  TextColumn get translationVersion => text()();

  TextColumn get translationSha256 => text()();

  DateTimeColumn get acquiredAt => dateTime()();

  TextColumn get validationReportRef => text()();

  @override
  Set<Column> get primaryKey => {id};
}
