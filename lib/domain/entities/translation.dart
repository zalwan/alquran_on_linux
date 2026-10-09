import 'ayah.dart';

/// One approved translation edition (e.g. a specific QuranEnc Indonesian
/// edition — see `docs/translation-clearance.md`). The edition identity is
/// what the content manifest and the in-app credits view must record.
class TranslationEdition {
  TranslationEdition({
    required this.id,
    required this.languageCode,
    required this.title,
    required this.publisher,
    required this.version,
  }) {
    for (final MapEntry<String, String> field in {
      'id': id,
      'languageCode': languageCode,
      'title': title,
      'publisher': publisher,
      'version': version,
    }.entries) {
      if (field.value.isEmpty) {
        throw ArgumentError('${field.key} must not be empty.');
      }
    }
  }

  final String id;
  final String languageCode;
  final String title;
  final String publisher;
  final String version;
}

/// Translation of one verse in one edition. Like [Ayah] text, translation
/// rows must be stored verbatim and joined to an existing [AyahKey] — orphan
/// rows fail validation (`docs/data-sources.md` §3.1).
class AyahTranslation {
  AyahTranslation({
    required this.key,
    required this.editionId,
    required String text,
  }) : text = text {
    AyahKey.checkValid(key.surahNumber, key.ayahNumber);
    if (editionId.isEmpty || text.isEmpty) {
      throw ArgumentError('editionId and text must not be empty.');
    }
  }

  final AyahKey key;
  final String editionId;
  final String text;
}
