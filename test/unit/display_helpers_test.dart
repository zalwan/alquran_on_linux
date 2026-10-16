import 'package:alquran_on_linux/core/format/relative_time.dart';
import 'package:alquran_on_linux/features/surah_index/revelation_label.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('revelation labels map metadata values to Indonesian', () {
    expect(revelationLabel('Meccan'), 'Makkiyah');
    expect(revelationLabel('Medinan'), 'Madaniyah');
    expect(revelationLabel(null), isNull);
    expect(revelationLabel('Unknown'), isNull);
  });

  test('relative time buckets', () {
    final DateTime now = DateTime.utc(2026, 10, 13, 12);
    expect(relativeTime(now, now: now), 'just now');
    expect(
      relativeTime(now.subtract(const Duration(minutes: 1)), now: now),
      '1 minute ago',
    );
    expect(
      relativeTime(now.subtract(const Duration(minutes: 45)), now: now),
      '45 minutes ago',
    );
    expect(
      relativeTime(now.subtract(const Duration(hours: 2)), now: now),
      '2 hours ago',
    );
    expect(
      relativeTime(now.subtract(const Duration(days: 1)), now: now),
      '1 day ago',
    );
    expect(
      relativeTime(now.subtract(const Duration(days: 40)), now: now),
      '1 month ago',
    );
    expect(
      relativeTime(now.subtract(const Duration(days: 400)), now: now),
      '1 year ago',
    );
    expect(
      relativeTime(now.add(const Duration(days: 1)), now: now),
      'just now',
    );
  });
}
