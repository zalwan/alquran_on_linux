import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme/app_typography.dart';
import 'preferences_repository.dart';

/// [SharedPreferences]-backed [PreferencesRepository].
///
/// Invalid stored values fall back to defaults instead of throwing, so a
/// corrupt prefs file can never break launch.
class SharedPreferencesRepository implements PreferencesRepository {
  SharedPreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  static const String keyThemeMode = 'theme_mode';
  static const String keyArabicFontSize = 'arabic_font_size';

  @override
  String loadThemeModeCode() {
    final String? code = _prefs.getString(keyThemeMode);
    if (code != null && PreferencesRepository.themeModeCodes.contains(code)) {
      return code;
    }
    return PreferencesRepository.themeModeSystem;
  }

  @override
  Future<void> saveThemeModeCode(String code) async {
    final String safe = PreferencesRepository.themeModeCodes.contains(code)
        ? code
        : PreferencesRepository.themeModeSystem;
    await _prefs.setString(keyThemeMode, safe);
  }

  @override
  double loadArabicFontSize() {
    final double? size = _prefs.getDouble(keyArabicFontSize);
    if (size == null) {
      return AppTypography.arabicVerseDefault;
    }
    return AppTypography.clampArabicSize(size);
  }

  @override
  Future<void> saveArabicFontSize(double size) async {
    await _prefs.setDouble(
      keyArabicFontSize,
      AppTypography.clampArabicSize(size),
    );
  }
}
