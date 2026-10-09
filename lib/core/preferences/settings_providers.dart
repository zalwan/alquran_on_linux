import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_typography.dart';
import 'preferences_repository.dart';

/// Repository override installed once in `main()`.
final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => throw UnimplementedError('preferencesRepositoryProvider not set'),
);

/// Theme mode choice, persisted via [PreferencesRepository].
class ThemeModeSetting extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final String code = ref
        .read(preferencesRepositoryProvider)
        .loadThemeModeCode();
    return _fromCode(code);
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref
        .read(preferencesRepositoryProvider)
        .saveThemeModeCode(_toCode(mode));
  }

  static ThemeMode _fromCode(String code) {
    return switch (code) {
      PreferencesRepository.themeModeLight => ThemeMode.light,
      PreferencesRepository.themeModeDark => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static String _toCode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => PreferencesRepository.themeModeLight,
      ThemeMode.dark => PreferencesRepository.themeModeDark,
      ThemeMode.system => PreferencesRepository.themeModeSystem,
    };
  }
}

final themeModeSettingProvider = NotifierProvider<ThemeModeSetting, ThemeMode>(
  ThemeModeSetting.new,
);

/// Adjustable Arabic verse size (20–40sp), persisted via
/// [PreferencesRepository].
class ArabicFontSizeSetting extends Notifier<double> {
  @override
  double build() {
    return ref.read(preferencesRepositoryProvider).loadArabicFontSize();
  }

  Future<void> set(double size) async {
    final double clamped = AppTypography.clampArabicSize(size);
    state = clamped;
    await ref.read(preferencesRepositoryProvider).saveArabicFontSize(clamped);
  }
}

final arabicFontSizeSettingProvider =
    NotifierProvider<ArabicFontSizeSetting, double>(ArabicFontSizeSetting.new);
