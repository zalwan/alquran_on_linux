import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light and dark [ThemeData] built manually from the §4 tokens.
///
/// The dark scheme is a separate definition — never an auto-inverted light
/// scheme. Reader widgets must read colors from
/// `Theme.of(context).colorScheme`, never from hard-coded hex.
abstract final class AppTheme {
  static const ColorScheme lightScheme = ColorScheme.light(
    primary: AppColors.primaryGreen,
    onPrimary: AppColors.paperWhite,
    primaryContainer: AppColors.paleGreen,
    onPrimaryContainer: AppColors.deepGreen,
    surface: AppColors.paperWhite,
    onSurface: AppColors.lightTextPrimary,
    surfaceContainerHighest: AppColors.paleGreen,
    outline: AppColors.lightOutline,
    error: Color(0xFFB3261E),
  );

  static const ColorScheme darkScheme = ColorScheme.dark(
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.deepGreen,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    outline: AppColors.darkOutline,
    error: Color(0xFFF2B8B5),
  );

  static ThemeData light() => _build(lightScheme, Brightness.light);

  static ThemeData dark() => _build(darkScheme, Brightness.dark);

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final bool isLight = brightness == Brightness.light;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      focusColor: scheme.primary.withValues(alpha: 0.12),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLight
              ? AppColors.primaryGreen
              : AppColors.darkPrimary,
          foregroundColor: isLight
              ? AppColors.paperWhite
              : AppColors.darkOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(48, 40),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(48, 40),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface,
        selectedIconTheme: IconThemeData(color: scheme.primary),
        unselectedIconTheme: IconThemeData(
          color: isLight
              ? AppColors.lightTextSecondary
              : AppColors.darkTextSecondary,
        ),
        selectedLabelTextStyle: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w600,
        ),
        indicatorColor: scheme.primaryContainer,
      ),
      dividerTheme: DividerThemeData(color: scheme.outline, thickness: 1),
    );
  }
}
