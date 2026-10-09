import 'package:alquran_on_linux/app/theme/app_colors.dart';
import 'package:alquran_on_linux/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The demo seed color must never return: every color in both schemes is
/// asserted against the agreed palette.
void main() {
  test('light scheme uses the agreed core palette', () {
    final ColorScheme scheme = AppTheme.lightScheme;

    expect(scheme.primary, AppColors.primaryGreen);
    expect(scheme.onPrimary, AppColors.paperWhite);
    expect(scheme.primaryContainer, AppColors.paleGreen);
    expect(scheme.onPrimaryContainer, AppColors.deepGreen);
    expect(scheme.surface, AppColors.paperWhite);
    expect(scheme.brightness, Brightness.light);
  });

  test('dark scheme never uses core greens as small-text colors', () {
    final ColorScheme scheme = AppTheme.darkScheme;

    expect(scheme.primary, AppColors.darkPrimary);
    expect(scheme.primary, isNot(AppColors.primaryGreen));
    expect(scheme.surface, AppColors.darkSurface);
    expect(scheme.onSurface, AppColors.darkTextPrimary);
    expect(scheme.brightness, Brightness.dark);
  });

  test('no demo purple remains in either scheme', () {
    final Set<Color> banned = {
      Colors.deepPurple,
      Colors.purple,
      Color(0xFF6750A4), // Material 3 baseline seed-derived primary
    };
    final List<Color> all = [
      AppTheme.lightScheme.primary,
      AppTheme.lightScheme.onPrimary,
      AppTheme.lightScheme.primaryContainer,
      AppTheme.lightScheme.onPrimaryContainer,
      AppTheme.lightScheme.surface,
      AppTheme.lightScheme.onSurface,
      AppTheme.darkScheme.primary,
      AppTheme.darkScheme.onPrimary,
      AppTheme.darkScheme.primaryContainer,
      AppTheme.darkScheme.onPrimaryContainer,
      AppTheme.darkScheme.surface,
      AppTheme.darkScheme.onSurface,
    ];
    for (final Color color in all) {
      expect(banned.contains(color), isFalse, reason: 'banned $color found');
    }
  });

  test('ThemeData builds for both modes with Material 3', () {
    expect(AppTheme.light().useMaterial3, isTrue);
    expect(AppTheme.dark().useMaterial3, isTrue);
  });
}
