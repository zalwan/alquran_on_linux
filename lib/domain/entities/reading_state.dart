import 'ayah.dart';

/// A locally saved verse marker. Identifies the verse, never its text.
class Bookmark {
  Bookmark({required this.key, required this.createdAt}) {
    AyahKey.checkValid(key.surahNumber, key.ayahNumber);
  }

  final AyahKey key;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bookmark &&
          key == other.key &&
          createdAt.isAtSameMomentAs(other.createdAt);

  @override
  int get hashCode => Object.hash(key, createdAt);

  @override
  String toString() => 'Bookmark($key at $createdAt)';
}

/// The most recently read location. Updated per the documented interaction
/// rule; must survive app restarts (MVP criterion).
class ReadingPosition {
  ReadingPosition({required this.key, required this.updatedAt}) {
    AyahKey.checkValid(key.surahNumber, key.ayahNumber);
  }

  final AyahKey key;
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingPosition &&
          key == other.key &&
          updatedAt.isAtSameMomentAs(other.updatedAt);

  @override
  int get hashCode => Object.hash(key, updatedAt);

  @override
  String toString() => 'ReadingPosition($key at $updatedAt)';
}
