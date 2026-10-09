import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_typography.dart';
import '../../core/preferences/settings_providers.dart';

/// Appearance settings: theme mode (System/Light/Dark) and adjustable
/// Arabic verse size with a live preview. All choices persist locally.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode mode = ref.watch(themeModeSettingProvider);
    final double fontSize = ref.watch(arabicFontSizeSettingProvider);
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Appearance', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text('Theme', style: theme.textTheme.titleMedium),
        RadioGroup<ThemeMode>(
          groupValue: mode,
          onChanged: (ThemeMode? value) {
            if (value != null) {
              ref.read(themeModeSettingProvider.notifier).set(value);
            }
          },
          child: const Column(
            children: [
              RadioListTile<ThemeMode>(
                title: Text('System'),
                subtitle: Text('Follow the desktop theme'),
                value: ThemeMode.system,
              ),
              RadioListTile<ThemeMode>(
                title: Text('Light'),
                subtitle: Text('Clean white reading space'),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: Text('Dark'),
                subtitle: Text('Calm greenish-black'),
                value: ThemeMode.dark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Arabic text size', style: theme.textTheme.titleMedium),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: fontSize,
                min: AppTypography.arabicVerseMin,
                max: AppTypography.arabicVerseMax,
                divisions:
                    ((AppTypography.arabicVerseMax -
                                AppTypography.arabicVerseMin) /
                            AppTypography.arabicVerseStep)
                        .round(),
                label: fontSize.toStringAsFixed(0),
                onChanged: (double value) {
                  ref.read(arabicFontSizeSettingProvider.notifier).set(value);
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              fontSize.toStringAsFixed(0),
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Preview at ${fontSize.toStringAsFixed(0)} pt',
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: fontSize / 2),
        ),
      ],
    );
  }
}
