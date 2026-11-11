import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_spacing.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../player_providers.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(myBookingsProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(S.navMyBookings),
          bottom:
              const TabBar(tabs: [Tab(text: S.upcoming), Tab(text: S.past)]),
        ),
        body: AsyncView(
          value: bookings,
          builder: (all) {
            final now = DateTime.now();
            final upcoming = all.where((b) => isUpcoming(b, now)).toList();
            final past = all
                .where((b) => !isUpcoming(b, now))
                .toList()
                .reversed
                .toList();
            return TabBarView(
              children: [
                _List(
                  bookings: upcoming,
                  empty: EmptyState(
                    icon: AppIcons.ball,
                    title: S.noUpcoming,
                    message: S.noUpcomingHint,
                    actionLabel: S.findPitch,
                    onAction: () => context.go(Routes.playerSearch),
                  ),
                ),
                _List(
                  bookings: past,
                  empty:
                      const EmptyState(icon: AppIcons.history, title: S.noPast),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.bookings, required this.empty});
  final List<Booking> bookings;
  final Widget empty;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return empty;
    return ListView.separated(
      padding:
          const EdgeInsets.fromLTRB(20, 16, 20, AppSpacing.navBarClearance),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) =>
          FadeSlideIn(index: i, child: PlayerBookingCard(booking: bookings[i])),
    );
  }
}

class PlayerBookingCard extends ConsumerWidget {
  const PlayerBookingCard({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(pitchProvider(booking.pitchId)).valueOrNull;
    final t = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(Routes.playerBooking(booking.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: PitchImage(
                  photoKey: pitch == null || pitch.photos.isEmpty
                      ? booking.pitchId
                      : pitch.photos.first,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pitch?.name ?? '', style: t.titleMedium),
                    const SizedBox(height: 2),
                    Text(Fmt.dayRelative(booking.startAt),
                        style:
                            t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
                    Text(Fmt.timeRange(booking.startAt, booking.endAt),
                        style: t.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    BookingStatusBadge(status: booking.status),
                  ],
                ),
              ),
              Icon(AppIcons.forward, color: AppColors.inkFaint),
            ],
          ),
        ),
      ),
    );
  }
}
