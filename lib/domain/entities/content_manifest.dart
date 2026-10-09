/// Provenance record for one packaged content set (`architecture.md` §4).
///
/// Arabic fields are always required. Translation fields are optional as a
/// group (all present or all absent): v1.0 ships Arabic-only per owner
/// decision 2026-10-09, and the cleared translation is added in v1.1
/// without reinstalling or touching user state. An undated, unchecksummed,
/// or unattributed dataset must never reach a release build
/// (`docs/data-sources.md` §3.4).
class ContentManifest {
  ContentManifest({
    required this.arabicSource,
    required this.arabicEdition,
    required this.arabicSha256,
    this.translationEditionId,
    this.translationVersion,
    this.translationSha256,
    required this.acquiredAt,
    required this.validationReportRef,
  }) {
    for (final MapEntry<String, String> field in {
      'arabicSource': arabicSource,
      'arabicEdition': arabicEdition,
      'arabicSha256': arabicSha256,
      'validationReportRef': validationReportRef,
    }.entries) {
      if (field.value.isEmpty) {
        throw ArgumentError('${field.key} must not be empty.');
      }
    }
    final List<String?> trio = [
      translationEditionId,
      translationVersion,
      translationSha256,
    ];
    final bool anySet = trio.any((v) => v != null);
    final bool allSet =
        trio.every((v) => v != null) && trio.every((v) => v!.isNotEmpty);
    if (anySet && !allSet) {
      throw ArgumentError(
        'Translation fields must be all present or all absent.',
      );
    }
  }

  final String arabicSource;
  final String arabicEdition;
  final String arabicSha256;
  final String? translationEditionId;
  final String? translationVersion;
  final String? translationSha256;
  final DateTime acquiredAt;
  final String validationReportRef;

  bool get hasTranslation => translationEditionId != null;

  /// Reads the committed `data/manifest/manifest.json` shape. Extra keys
  /// (e.g. file names) are ignored; missing required keys throw.
  factory ContentManifest.fromJson(Map<String, Object?> json) {
    String required(String key) {
      final Object? value = json[key];
      if (value is! String || value.isEmpty) {
        throw FormatException('Manifest is missing required key: $key.');
      }
      return value;
    }

    String? optional(String key) {
      final Object? value = json[key];
      if (value == null) {
        return null;
      }
      if (value is! String || value.isEmpty) {
        throw FormatException('Manifest key is not a non-empty string: $key.');
      }
      return value;
    }

    final Object? acquired = json['acquiredAt'];
    if (acquired is! String) {
      throw const FormatException('Manifest is missing acquiredAt.');
    }
    return ContentManifest(
      arabicSource: required('arabicSource'),
      arabicEdition: required('arabicEdition'),
      arabicSha256: required('arabicSha256'),
      translationEditionId: optional('translationEditionId'),
      translationVersion: optional('translationVersion'),
      translationSha256: optional('translationSha256'),
      acquiredAt: DateTime.parse(acquired),
      validationReportRef: required('validationReportRef'),
    );
  }
}
