/// Provenance record for one packaged content set (`architecture.md` §4).
///
/// Every field is required: an undated, unchecksummed, or unattributed
/// dataset must never reach a release build (`docs/data-sources.md` §3.4).
class ContentManifest {
  ContentManifest({
    required this.arabicSource,
    required this.arabicEdition,
    required this.arabicSha256,
    required this.translationEditionId,
    required this.translationVersion,
    required this.translationSha256,
    required this.acquiredAt,
    required this.validationReportRef,
  }) {
    for (final MapEntry<String, String> field in {
      'arabicSource': arabicSource,
      'arabicEdition': arabicEdition,
      'arabicSha256': arabicSha256,
      'translationEditionId': translationEditionId,
      'translationVersion': translationVersion,
      'translationSha256': translationSha256,
      'validationReportRef': validationReportRef,
    }.entries) {
      if (field.value.isEmpty) {
        throw ArgumentError('${field.key} must not be empty.');
      }
    }
  }

  final String arabicSource;
  final String arabicEdition;
  final String arabicSha256;
  final String translationEditionId;
  final String translationVersion;
  final String translationSha256;
  final DateTime acquiredAt;
  final String validationReportRef;
}
