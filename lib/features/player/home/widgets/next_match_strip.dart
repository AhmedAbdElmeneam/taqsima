part of 'player_home_widgets_imports.dart';

/// Next booking inside the hero: live badge or countdown.
/// Watches the clock so the countdown stays current.
class NextMatchStrip extends ConsumerWidget {
  const NextMatchStrip({super.key, required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(pitchProvider(booking.pitchId)).valueOrNull;
    final now = ref.now;
    final live = !booking.startAt.isAfter(now) && booking.endAt.isAfter(now);
    final minutes = booking.startAt.difference(now).inMinutes;
    final soon = !live && minutes < 24 * 60;
    final pending = booking.status == BookingStatus.pending;
    final day = Fmt.isSameDay(booking.startAt, now)
        ? ''
        : '${Fmt.dayRelative(booking.startAt)} ';

    return HeroStrip(
      onTap: onTap,
      child: HeroStripBooking(
        live: live,
        label: live
            ? S.playingNow
            : pending
                ? '${S.yourNextMatch} • ${S.awaitingConfirmation}'
                : S.yourNextMatch,
        title: '${pitch?.name ?? ''} • $day${Fmt.time(booking.startAt)}',
        countdown: soon ? S.inTime(minutes) : null,
      ),
    );
  }
}
