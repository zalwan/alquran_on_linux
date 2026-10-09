import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/bookmarks/bookmarks_page.dart';
import '../features/home/home_page.dart';
import '../features/reader/reader_page.dart';
import '../features/settings/settings_page.dart';
import '../features/surah_index/surah_index_page.dart';

/// Route paths. Reader routes carry the surah number; surah/ayah deep
/// details arrive with the Phase 2 content work.
abstract final class AppRoutes {
  static const String home = '/';
  static const String surahs = '/surahs';
  static const String bookmarks = '/bookmarks';
  static const String settings = '/settings';

  static String reader(int surahNumber) => '$surahs/$surahNumber';
}

final List<({String path, String label, IconData icon})> _destinations = [
  (path: AppRoutes.home, label: 'Home', icon: Icons.home_outlined),
  (path: AppRoutes.surahs, label: 'Index', icon: Icons.library_books_outlined),
  (path: AppRoutes.bookmarks, label: 'Bookmarks', icon: Icons.bookmark_border),
  (path: AppRoutes.settings, label: 'Settings', icon: Icons.settings_outlined),
];

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppShell(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.surahs,
            builder: (context, state) => const SurahIndexPage(),
          ),
          GoRoute(
            path: '${AppRoutes.surahs}/:number',
            builder: (context, state) {
              final int number =
                  int.tryParse(state.pathParameters['number'] ?? '') ?? 0;
              return ReaderPage(surahNumber: number);
            },
          ),
          GoRoute(
            path: AppRoutes.bookmarks,
            builder: (context, state) => const BookmarksPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}

/// GNOME-first desktop shell: navigation rail, not a phone-style bottom bar.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    for (int i = 0; i < _destinations.length; i++) {
      final String path = _destinations[i].path;
      if (location == path ||
          (path != AppRoutes.home && location.startsWith('$path/'))) {
        selectedIndex = i;
      }
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) =>
                context.go(_destinations[index].path),
            labelType: NavigationRailLabelType.selected,
            destinations: [
              for (final destination in _destinations)
                NavigationRailDestination(
                  icon: Icon(destination.icon),
                  label: Text(destination.label),
                ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
