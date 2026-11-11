import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../../auth/session_controller.dart';
import 'pitch_switcher.dart';

/// Owner home header styled like a stadium scoreboard: greeting, date,
/// pitch (tap to switch) and a live strip with the next booking countdown.
class MatchdayHeader extends ConsumerWidget {
  const MatchdayHeader({super.key, required this.pitch, required this.slots});

  final Pitch pitch;

  /// Today's computed slots (null while loading).
  final List<TimeSlot>? slots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);
    final firstName = (user?.name ?? '').split(' ').take(2).join(' ');

    return HeroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroGreeting(name: firstName),
          const SizedBox(height: 4),
          PitchSwitcher(pitch: pitch, onDark: true),
          const SizedBox(height: 12),
          _NextBookingStrip(slots: slots),
        ],
      ),
    );
  }
}

/// "Playing now" or "next booking in N minutes".
class _NextBookingStrip extends ConsumerWidget {
  const _NextBookingStrip({required this.slots});
  final List<TimeSlot>? slots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final booked = (slots ?? const <TimeSlot>[])
        .where((s) =>
            s.booking != null && s.booking!.status != BookingStatus.pending)
        .toList();
    final live = booked
        .where((s) => !s.startAt.isAfter(now) && s.endAt.isAfter(now))
        .firstOrNull;
    final next = booked.where((s) => s.startAt.isAfter(now)).firstOrNull;
    final slot = live ?? next;

    String? who;
    final b = slot?.booking;
    if (b != null) {
      who = b.source == BookingSource.manual
          ? (b.customerName ?? S.noName)
          : ref.watch(userProvider(b.userId!)).valueOrNull?.name;
    }

    return HeroStrip(
      child: slot == null
          ? const HeroStripMessage(
              icon: AppIcons.confirmed, text: S.noMoreBookingsToday)
          : HeroStripBooking(
              live: live != null,
              label: live != null ? S.playingNow : S.nextBooking,
              title: '${Fmt.time(slot.startAt)}${who == null ? '' : ' • $who'}',
              countdown: live == null
                  ? S.inTime(slot.startAt.difference(now).inMinutes)
                  : null,
            ),
    );
  }
}
