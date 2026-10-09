import 'package:flutter/material.dart';

/// Core palette from `docs/theme.md`.
///
/// Only [primaryGreen], [paperWhite], [paleGreen], and [deepGreen] are the
/// agreed core colors. Every other value is a neutral/green derivative
/// required for contrast — no new hue may be introduced without a design
/// review.
abstract final class AppColors {
  // Core palette.
  static const Color primaryGreen = Color(0xFF166534);
  static const Color paperWhite = Color(0xFFFFFFFF);
  static const Color paleGreen = Color(0xFFF0FDF4);
  static const Color deepGreen = Color(0xFF14532D);

  // Light-mode derivatives.
  static const Color lightTextPrimary = Color(0xFF101815);
  static const Color lightTextSecondary = Color(0xFF3F4D46);
  static const Color lightTextArabic = Color(0xFF0C1A12);
  static const Color lightOutline = Color(0xFFBBD7C5);
  static const Color primaryHover = Color(0xFF104E28);

  // Dark-mode derivatives. Pure white and the core greens are never used
  // as small text on dark surfaces (contrast); the lighter accents below
  // take that role.
  static const Color darkPrimary = Color(0xFF4ADE80);
  static const Color darkOnPrimary = Color(0xFF052E16);
  static const Color darkOnPrimaryContainer = Color(0xFFDCFCE7);
  static const Color darkBackground = Color(0xFF0B1F14);
  static const Color darkSurface = Color(0xFF0F2A1C);
  static const Color darkSurfaceVariant = Color(0xFF143726);
  static const Color darkOutline = Color(0xFF2D5540);
  static const Color darkTextPrimary = Color(0xFFF5F7F5);
  static const Color darkTextSecondary = Color(0xFFC4D4C9);
  static const Color darkTextArabic = Color(0xFFF2F7F3);
}
