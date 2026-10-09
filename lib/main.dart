import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/preferences/settings_providers.dart';
import 'core/preferences/shared_preferences_repository.dart';
import 'data/content/content_bootstrap.dart';
import 'data/database/app_database.dart';
import 'data/database/database_providers.dart';
import 'data/repositories/drift_content_repository.dart';
import 'features/reader/reader_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final SharedPreferencesRepository repository = SharedPreferencesRepository(
    prefs,
  );
  // File-backed user-state database under the app-specific support
  // directory (~/.var/app/<id>/ in Flatpak — no extra permission needed).
  final Directory supportDir = await getApplicationSupportDirectory();
  final AppDatabase database = AppDatabase(
    File('${supportDir.path}/alquran.db'),
  );
  // First launch: seed the approved v1.0 Arabic dataset from the bundled,
  // checksummed files. Failures degrade to the unseeded pending states —
  // they must never prevent launch.
  try {
    await ensureContentSeeded(database, rootBundle);
  } catch (e) {
    debugPrint('Content seeding failed (app continues unseeded): $e');
  }
  runApp(
    ProviderScope(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(repository),
        appDatabaseProvider.overrideWithValue(database),
        quranContentProvider.overrideWithValue(
          DriftQuranContentRepository(database),
        ),
      ],
      child: const AlquranApp(),
    ),
  );
}

/// Surfaces the bundled Amiri OFL text in the app license page, as the
/// SIL Open Font License requires.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    final String text = await rootBundle.loadString(
      'assets/fonts/OFL-Amiri.txt',
    );
    yield LicenseEntryWithLineBreaks(['Amiri'], text);
  });
}
