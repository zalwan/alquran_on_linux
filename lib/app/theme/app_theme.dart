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
    surfaceContainerHigh: Color(0xFFE4F3E9),
    surfaceContainerLow: Color(0xFFF7FCF9),
    outline: AppColors.lightOutline,
    outlineVariant: Color(0xFFD3E8DA),
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
    surfaceContainerHigh: Color(0xFF12271B),
    surfaceContainerLow: Color(0xFF0A1C12),
    outline: AppColors.darkOutline,
    outlineVariant: Color(0xFF1E3A2B),
    error: Color(0xFFF2B8B5),
  );

  /// Corner radii shared by every card, sheet, and panel.
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 20;

  /// Readable single-column width on wide desktop windows.
  static const double maxReadingWidth = 720;
  static const double maxDashboardWidth = 560;

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
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      chipTheme: themeChip(scheme),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        isDense: true,
      ),
    );
  }

  static ChipThemeData themeChip(ColorScheme scheme) {
    return ChipThemeData(
      backgroundColor: scheme.primaryContainer,
      labelStyle: TextStyle(color: scheme.onPrimaryContainer, fontSize: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}
