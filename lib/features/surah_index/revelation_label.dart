/// Indonesian display labels for the revelation type carried by [Surah].
/// Unknown or missing values yield null so rows degrade to no badge.
String? revelationLabel(String? revelationType) {
  return switch (revelationType) {
    'Meccan' => 'Makkiyah',
    'Medinan' => 'Madaniyah',
    _ => null,
  };
}
