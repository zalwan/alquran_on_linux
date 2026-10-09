import '../entities/ayah.dart';
import '../repositories/quran_content_repository.dart';

/// Open a surah for reading: validates the number, then returns its verses
/// in source order. Throws [RangeError] for numbers outside 1–114.
class OpenSurah {
  const OpenSurah(this._content);

  final QuranContentRepository _content;

  Future<List<Ayah>> call(int surahNumber) {
    RangeError.checkValueInInterval(surahNumber, 1, 114, 'surahNumber');
    return _content.getAyahs(surahNumber);
  }
}
