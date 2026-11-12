part of 'booking_requests_widgets_imports.dart';

/// Player, pitch, price, day/time and accept / reject.
class RequestCard extends ConsumerWidget {
  const RequestCard({
    super.key,
    required this.booking,
    required this.onTap,
    required this.onAnswer,
  });

  final Booking booking;
  final VoidCallback onTap;
  final Future<void> Function(bool accept) onAnswer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = booking;
    final player = ref.watch(userProvider(b.userId ?? '')).valueOrNull;
    final pitch = ref.watch(pitchProvider(b.pitchId)).valueOrNull;
    final t = Theme.of(context).textTheme;

    return PressableScale(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.infoLight,
                      child: Text(
                        (player?.name ?? ' ').characters.first,
                        style: t.titleLarge?.copyWith(color: AppColors.info),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(player?.name ?? '', style: t.titleMedium),
                          Text(pitch?.name ?? '',
                              style: t.bodyMedium
                                  ?.copyWith(color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                    Text(S.price(b.price),
                        style:
                            t.titleMedium?.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 12),
                AppPanel(
                  color: AppColors.background,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(AppIcons.calendar, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${Fmt.dayRelative(b.startAt)} • ${Fmt.timeRange(b.startAt, b.endAt)}',
                          style: t.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                RequestActions(onAnswer: onAnswer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
