import 'package:alquran_on_linux/app/theme/app_typography.dart';
import 'package:alquran_on_linux/core/preferences/preferences_repository.dart';
import 'package:alquran_on_linux/core/preferences/settings_providers.dart';
import 'package:alquran_on_linux/core/preferences/shared_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> makeContainer(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final SharedPreferencesRepository repo = SharedPreferencesRepository(prefs);
  final ProviderContainer container = ProviderContainer(
    overrides: [preferencesRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('theme mode defaults to system and round-trips', () async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProviderContainer container = ProviderContainer(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(
          SharedPreferencesRepository(prefs),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(themeModeSettingProvider), ThemeMode.system);

    await container.read(themeModeSettingProvider.notifier).set(ThemeMode.dark);
    expect(container.read(themeModeSettingProvider), ThemeMode.dark);

    // A fresh repository over the same store sees the persisted value.
    final PreferencesRepository fresh = SharedPreferencesRepository(prefs);
    expect(fresh.loadThemeModeCode(), PreferencesRepository.themeModeDark);
  });

  test('invalid stored theme mode falls back to system', () async {
    final ProviderContainer container = await makeContainer({
      SharedPreferencesRepository.keyThemeMode: 'ultraviolet',
    });

    expect(container.read(themeModeSettingProvider), ThemeMode.system);
  });

  test('arabic font size defaults, clamps, and persists', () async {
    final ProviderContainer container = await makeContainer({});

    expect(
      container.read(arabicFontSizeSettingProvider),
      AppTypography.arabicVerseDefault,
    );

    await container.read(arabicFontSizeSettingProvider.notifier).set(500);
    expect(
      container.read(arabicFontSizeSettingProvider),
      AppTypography.arabicVerseMax,
    );

    await container.read(arabicFontSizeSettingProvider.notifier).set(1);
    expect(
      container.read(arabicFontSizeSettingProvider),
      AppTypography.arabicVerseMin,
    );
  });

  test('repository clamps out-of-range stored font size', () async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesRepository.keyArabicFontSize: 999.0,
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final PreferencesRepository repo = SharedPreferencesRepository(prefs);

    expect(repo.loadArabicFontSize(), AppTypography.arabicVerseMax);
  });
}
