import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/bookmarks/bookmarks_page.dart';
import '../features/credits/credits_page.dart';
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
  static const String about = '/about';

  static String reader(int surahNumber) => '$surahs/$surahNumber';
}

final List<({String path, String label, IconData icon})> _destinations = [
  (path: AppRoutes.home, label: 'Home', icon: Icons.home_outlined),
  (path: AppRoutes.surahs, label: 'Index', icon: Icons.library_books_outlined),
  (path: AppRoutes.bookmarks, label: 'Bookmarks', icon: Icons.bookmark_border),
  (path: AppRoutes.settings, label: 'Settings', icon: Icons.settings_outlined),
  (path: AppRoutes.about, label: 'About', icon: Icons.info_outlined),
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
          for (final MapEntry<String, Widget Function()> entry in {
            AppRoutes.home: () => const HomePage(),
            AppRoutes.surahs: () => const SurahIndexPage(),
            AppRoutes.bookmarks: () => const BookmarksPage(),
            AppRoutes.settings: () => const SettingsPage(),
            AppRoutes.about: () => const CreditsPage(),
          }.entries)
            GoRoute(
              path: entry.key,
              pageBuilder: (context, state) =>
                  _fadeSlidePage(child: entry.value()),
            ),
          GoRoute(
            path: '${AppRoutes.surahs}/:number',
            pageBuilder: (context, state) {
              final int number =
                  int.tryParse(state.pathParameters['number'] ?? '') ?? 0;
              return _fadeSlidePage(child: ReaderPage(surahNumber: number));
            },
          ),
        ],
      ),
    ],
  );
}

/// Soft fade+slide transition; instant when the platform requests reduced
/// motion (restrained motion policy).
CustomTransitionPage<void> _fadeSlidePage({required Widget child}) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.disableAnimationsOf(context)) {
        return child;
      }
      return FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
        child: SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(0.02, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: child,
        ),
      );
    },
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
    // Extended labels on wide desktop windows, compact rail otherwise.
    final bool extended = MediaQuery.sizeOf(context).width >= 1100;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            minExtendedWidth: 220,
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) =>
                context.go(_destinations[index].path),
            // Extended rails show labels beside icons; the selected-only
            // label mode is only valid when compact (framework assertion).
            labelType: extended ? null : NavigationRailLabelType.selected,
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
