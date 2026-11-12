import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/active_theme.dart';
import '../data/providers.dart';

/// Shows [child] in the theme the pitch's owner picked. Used by the routes
/// of every player screen that belongs to one pitch (details, slots,
/// confirm, success, booking details).
class PitchThemed extends ConsumerWidget {
  const PitchThemed({super.key, required this.pitchId, required this.child});

  final String pitchId;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) => PitchThemeScope(
        theme: ref.watch(pitchProvider(pitchId)).valueOrNull?.theme,
        child: child,
      );
}

/// Same as [PitchThemed], starting from a booking id.
class BookingPitchThemed extends ConsumerWidget {
  const BookingPitchThemed(
      {super.key, required this.bookingId, required this.child});

  final String bookingId;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitchId = ref.watch(bookingProvider(bookingId)).valueOrNull?.pitchId;
    final theme = pitchId == null
        ? null
        : ref.watch(pitchProvider(pitchId)).valueOrNull?.theme;
    return PitchThemeScope(theme: theme, child: child);
  }
}
