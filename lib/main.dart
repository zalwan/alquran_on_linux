import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/preferences/settings_providers.dart';
import 'core/preferences/shared_preferences_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final SharedPreferencesRepository repository = SharedPreferencesRepository(
    prefs,
  );
  runApp(
    ProviderScope(
      overrides: [preferencesRepositoryProvider.overrideWithValue(repository)],
      child: const AlquranApp(),
    ),
  );
}
