import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/preferences/settings_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Application root: router + light/dark themes from `docs/theme.md`.
class AlquranApp extends ConsumerStatefulWidget {
  const AlquranApp({super.key});

  @override
  ConsumerState<AlquranApp> createState() => _AlquranAppState();
}

class _AlquranAppState extends ConsumerState<AlquranApp> {
  late final router = buildRouter();

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = ref.watch(themeModeSettingProvider);
    return MaterialApp.router(
      title: 'Alquran',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
