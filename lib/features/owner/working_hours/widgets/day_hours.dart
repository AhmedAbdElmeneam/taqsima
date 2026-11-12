part of 'working_hours_widgets_imports.dart';

/// One weekday's draft hours (minutes from midnight; `to <= from`
/// means it closes after midnight).
@immutable
class DayHours {
  const DayHours({required this.open, required this.from, required this.to});

  final bool open;
  final int from;
  final int to;

  DayHours copyWith({bool? open, int? from, int? to}) => DayHours(
      open: open ?? this.open, from: from ?? this.from, to: to ?? this.to);
}
