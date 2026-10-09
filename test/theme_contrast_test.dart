import 'dart:math' as math;

import 'package:alquran_on_linux/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.x relative luminance + contrast ratio, implemented directly so the
/// test pins the exact definition (no dependency behavior involved).
double _linearize(double channel) => channel <= 0.04045
    ? channel / 12.92
    : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();

double _luminance(Color color) =>
    0.2126 * _linearize(color.r) +
    0.7152 * _linearize(color.g) +
    0.0722 * _linearize(color.b);

double _ratio(Color a, Color b) {
  final double light = math.max(_luminance(a), _luminance(b));
  final double dark = math.min(_luminance(a), _luminance(b));
  return (light + 0.05) / (dark + 0.05);
}

/// Every pair from `docs/theme.md` §4.3 must meet WCAG 2.2 AA body-text
/// contrast (≥ 4.5:1). Measured 2026-10-09 — all pass with margin; the
/// lowest pair is 7.13:1. Any token change that breaks these fails here.
void main() {
  const Map<String, (Color, Color)> pairs = {
    'text-primary on background (light)': (
      AppColors.lightTextPrimary,
      AppColors.paperWhite,
    ),
    'text-primary on background (dark)': (
      AppColors.darkTextPrimary,
      AppColors.darkBackground,
    ),
    'arabic on background (light)': (
      AppColors.lightTextArabic,
      AppColors.paperWhite,
    ),
    'arabic on highlight (light)': (
      AppColors.lightTextArabic,
      AppColors.paleGreen,
    ),
    'arabic on background (dark)': (
      AppColors.darkTextArabic,
      AppColors.darkBackground,
    ),
    'arabic on highlight (dark)': (
      AppColors.darkTextArabic,
      AppColors.deepGreen,
    ),
    'on-primary on primary (light)': (
      AppColors.paperWhite,
      AppColors.primaryGreen,
    ),
    'on-primary on primary (dark)': (
      AppColors.darkOnPrimary,
      AppColors.darkPrimary,
    ),
    'on-container on container (light)': (
      AppColors.deepGreen,
      AppColors.paleGreen,
    ),
    'on-container on container (dark)': (
      AppColors.darkOnPrimaryContainer,
      AppColors.deepGreen,
    ),
    'primary as small text (light)': (
      AppColors.primaryGreen,
      AppColors.paperWhite,
    ),
    'accent as small text (dark)': (
      AppColors.darkPrimary,
      AppColors.darkBackground,
    ),
    'secondary on background (light)': (
      AppColors.lightTextSecondary,
      AppColors.paperWhite,
    ),
    'secondary on background (dark)': (
      AppColors.darkTextSecondary,
      AppColors.darkBackground,
    ),
  };

  for (final MapEntry<String, (Color, Color)> entry in pairs.entries) {
    test('${entry.key} meets 4.5:1', () {
      final (Color foreground, Color background) = entry.value;
      expect(_ratio(foreground, background), greaterThanOrEqualTo(4.5));
    });
  }
}
