/// Local-preference storage contract.
///
/// Implementations persist user choices only — never Quran content.
/// Theme mode travels as a plain string code (`system`, `light`, `dark`)
/// so this contract stays independent of Flutter widget types.
abstract class PreferencesRepository {
  static const String themeModeSystem = 'system';
  static const String themeModeLight = 'light';
  static const String themeModeDark = 'dark';

  static const Set<String> themeModeCodes = {
    themeModeSystem,
    themeModeLight,
    themeModeDark,
  };

  /// Reading density (`docs/theme.md` §7.3): comfortable (default) or
  /// compact. Both keep Arabic line height ≥ 1.8.
  static const String densityComfortable = 'comfortable';
  static const String densityCompact = 'compact';

  static const Set<String> densityCodes = {densityComfortable, densityCompact};

  String loadThemeModeCode();

  Future<void> saveThemeModeCode(String code);

  double loadArabicFontSize();

  Future<void> saveArabicFontSize(double size);

  String loadDensityCode();

  Future<void> saveDensityCode(String code);
}
