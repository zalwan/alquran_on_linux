import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/preferences/settings_providers.dart';
import 'core/preferences/shared_preferences_repository.dart';
import 'data/database/app_database.dart';
import 'data/database/database_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final SharedPreferencesRepository repository = SharedPreferencesRepository(
    prefs,
  );
  // File-backed user-state database under the app-specific support
  // directory (~/.var/app/<id>/ in Flatpak — no extra permission needed).
  // Quran content tables arrive with the approved dataset (Phase 2).
  final Directory supportDir = await getApplicationSupportDirectory();
  final AppDatabase database = AppDatabase(
    File('${supportDir.path}/alquran.db'),
  );
  runApp(
    ProviderScope(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(repository),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const AlquranApp(),
    ),
  );
}
