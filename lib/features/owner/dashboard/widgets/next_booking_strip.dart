part of 'owner_dashboard_widgets_imports.dart';

/// "Playing now" or "next booking in N minutes".
/// Watches the clock so the countdown stays current.
class NextBookingStrip extends ConsumerWidget {
  const NextBookingStrip({super.key, required this.slots});
  final List<TimeSlot>? slots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.now;
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
