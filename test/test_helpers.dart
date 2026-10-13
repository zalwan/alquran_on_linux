import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The navigation rail shares icons with page content (dashboard cards,
/// verse-card actions), so rail taps must be scoped to disambiguate.
Finder railIcon(IconData icon) {
  return find.descendant(
    of: find.byType(NavigationRail),
    matching: find.byIcon(icon),
  );
}

Future<void> tapRail(WidgetTester tester, IconData icon) {
  return tester.tap(railIcon(icon));
}
