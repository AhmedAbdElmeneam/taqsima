part of 'my_bookings_widgets_imports.dart';

/// Booking row: pitch thumb, day/time, status and a countdown when soon.
class PlayerBookingCard extends ConsumerWidget {
  const PlayerBookingCard(
      {super.key, required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(pitchProvider(booking.pitchId)).valueOrNull;
    final t = Theme.of(context).textTheme;
    final now = DateTime.now();
    final minutesLeft = booking.startAt.difference(now).inMinutes;
    final soon = isUpcoming(booking, now) && minutesLeft < 24 * 60;

    return PressableScale(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          // Colored edge = booking status, same pattern as the owner rows.
          child: StatusEdge(
            color: booking.status.color,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  PitchThumb(
                      photoKey: pitch?.coverPhoto ?? booking.pitchId,
                      size: 72,
                      radius: 14),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pitch?.name ?? '', style: t.titleMedium),
                        const SizedBox(height: 2),
                        Text(Fmt.dayRelative(booking.startAt),
                            style: t.bodyMedium
                                ?.copyWith(color: AppColors.inkMuted)),
                        Text(Fmt.timeRange(booking.startAt, booking.endAt),
                            style: t.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            BookingStatusBadge(status: booking.status),
                            if (soon) ...[
                              const SizedBox(width: 6),
                              AppBadge(
                                label: S.inTime(minutesLeft.clamp(0, 1 << 30)),
                                color: AppColors.primary,
                                background: AppColors.primaryLight,
                                icon: AppIcons.clock,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(AppIcons.forward, color: AppColors.inkFaint),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
