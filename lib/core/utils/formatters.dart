import '../l10n/app_strings.dart';

/// Date/time helpers. dayOfWeek convention across the app: 0 = Sunday … 6 = Saturday.
abstract final class Fmt {
  static int dayOfWeek(DateTime d) => d.weekday % 7;

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Left-to-right mark. Put before numbers with separators ("8:00", "3.5")
  /// so they are not flipped inside Arabic text.
  static final lrm = String.fromCharCode(0x200E);

  /// Keeps a number like "3.5" in order inside RTL text.
  static String ltr(String s) => '$lrm$s';

  /// "8:00 م"
  static String time(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    return '$lrm$h:$m ${d.hour < 12 ? S.am : S.pm}';
  }

  /// Minutes from midnight → "8:00 م". Values ≥ 1440 wrap to next day.
  static String minutesOfDay(int minutes) {
    final m = minutes % (24 * 60);
    return time(DateTime(2000, 1, 1, m ~/ 60, m % 60));
  }

  /// "8:00 م - 9:00 م"
  static String timeRange(DateTime start, DateTime end) =>
      '${time(start)} - ${time(end)}';

  /// "الخميس 12 نوفمبر"
  static String dayLong(DateTime d) =>
      '${S.weekdays[dayOfWeek(d)]} ${d.day} ${S.months[d.month - 1]}';

  /// "النهارده" / "بكره" / "الخميس 12 نوفمبر"
  static String dayRelative(DateTime d, {DateTime? now}) {
    final today = dateOnly(now ?? DateTime.now());
    final diff = dateOnly(d).difference(today).inDays;
    if (diff == 0) return S.today;
    if (diff == 1) return S.tomorrow;
    return dayLong(d);
  }

  static String duration(Duration d) => S.slotDuration(d.inMinutes);

  /// "01012345678" → "0101 234 5678"
  static String phone(String p) {
    if (p.length != 11) return p;
    // A left-to-right mark before each group keeps the groups in order
    // inside Arabic (RTL) text.
    final lrm = String.fromCharCode(0x200E);
    return '$lrm${p.substring(0, 4)} $lrm${p.substring(4, 7)} '
        '$lrm${p.substring(7)}';
  }
}
