import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../owner_providers.dart';
import 'widgets/matchday_header.dart';
import 'widgets/occupancy_meter.dart';
import 'widgets/stat_card.dart';
import 'widgets/today_slot_row.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(currentOwnerPitchProvider);
    return TabPage(
      child: AsyncView(
        value: pitch,
        builder: (p) => p == null
            ? EmptyState(
                icon: AppIcons.pitch,
                title: S.noPitchYet,
                message: S.noPitchYetHint,
                actionLabel: S.addPitch,
                onAction: () => context.push(Routes.ownerPitchForm),
              )
            : _Dashboard(pitch: p),
      ),
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard({required this.pitch});
  final Pitch pitch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = todayDate();
    final slots = ref.watch(daySlotsProvider((pitch.id, today)));
    final requests = ref.watch(ownerRequestsProvider).valueOrNull ?? const [];
    final t = Theme.of(context).textTheme;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.refreshData(),
      child: ListView(
        padding:
            const EdgeInsets.fromLTRB(20, 8, 20, AppSpacing.navBarClearance),
        children: [
          MatchdayHeader(pitch: pitch, slots: slots.valueOrNull),
          const SizedBox(height: 14),
          if (pitch.status == PitchStatus.pending) ...[
            AppPanel(
              color: AppColors.warningLight,
              child: Row(
                children: [
                  Icon(AppIcons.clock, color: AppColors.pending),
                  const SizedBox(width: 10),
                  Expanded(child: Text(S.underReviewHint, style: t.bodyMedium)),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (requests.isNotEmpty) ...[
            Material(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                onTap: () => context.go(Routes.ownerRequests),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Icon(AppIcons.bellRinging,
                          color: AppColors.info, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(S.pendingRequestsBanner(requests.length),
                            style:
                                t.titleMedium?.copyWith(color: AppColors.info)),
                      ),
                      Icon(AppIcons.forward, color: AppColors.info, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          AsyncView(
            value: slots,
            builder: (list) {
              final booked = list.where((s) =>
                  s.booking != null &&
                  s.booking!.status != BookingStatus.pending);
              final free = list.where((s) => s.isBookable).length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: StatCard(
                          label: S.todaysRevenue,
                          value: S.price(revenueOf(list)),
                          amount: revenueOf(list),
                          icon: AppIcons.moneyFill,
                          highlight: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: StatCard(
                          label: S.bookingsCount,
                          value: '${booked.length}',
                          icon: AppIcons.calendarCheck,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: StatCard(
                          label: S.freeSlots,
                          value: '$free',
                          icon: AppIcons.calendarPlus,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OccupancyMeter(slots: list),
                  const SizedBox(height: 22),
                  SectionHeader(
                    title: S.todaysBookings,
                    action: S.navCalendar,
                    onAction: () => context.go(Routes.ownerCalendar),
                  ),
                  Text(S.tapFreeSlotHint, style: t.bodySmall),
                  const SizedBox(height: 10),
                  if (list.isEmpty)
                    const EmptyState(
                      icon: AppIcons.closed,
                      title: S.closedThisDay,
                    )
                  else
                    for (final (i, s) in list.indexed)
                      FadeSlideIn(index: i, child: TodaySlotRow(slot: s)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
