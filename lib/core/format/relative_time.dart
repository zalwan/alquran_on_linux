/// Human relative timestamps for bookmark rows ("just now", "3 days ago").
/// Pure Dart, English UI strings, no dependencies.
String relativeTime(DateTime moment, {DateTime? now}) {
  final DateTime current = (now ?? DateTime.now()).toUtc();
  Duration diff = current.difference(moment.toUtc());
  if (diff.isNegative) {
    diff = Duration.zero;
  }
  if (diff.inSeconds < 60) {
    return 'just now';
  }
  if (diff.inMinutes < 60) {
    final int m = diff.inMinutes;
    return '$m minute${m == 1 ? '' : 's'} ago';
  }
  if (diff.inHours < 24) {
    final int h = diff.inHours;
    return '$h hour${h == 1 ? '' : 's'} ago';
  }
  if (diff.inDays < 30) {
    final int d = diff.inDays;
    return '$d day${d == 1 ? '' : 's'} ago';
  }
  if (diff.inDays < 365) {
    final int months = diff.inDays ~/ 30;
    return '$months month${months == 1 ? '' : 's'} ago';
  }
  final int years = diff.inDays ~/ 365;
  return '$years year${years == 1 ? '' : 's'} ago';
}
