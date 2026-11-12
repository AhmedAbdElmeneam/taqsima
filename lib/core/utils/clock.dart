import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current time, refreshed every 30 seconds. Watch it in widgets that show
/// time-relative text ("بعد 10 دقائق", "يُلعب الآن") so they stay correct
/// while the screen is open.
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
});

extension ClockRef on WidgetRef {
  /// The ticking clock, falling back to "now" before the first tick.
  DateTime get now => watch(clockProvider).valueOrNull ?? DateTime.now();
}
