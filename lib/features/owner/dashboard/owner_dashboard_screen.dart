import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_spacing.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../calendar/slot_action_sheet.dart';
import '../owner_providers.dart';
import 'matchday_header.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(currentOwnerPitchProvider);
    return Scaffold(
      body: TopFade(
        height: MediaQuery.paddingOf(context).top + 24,
        child: SafeArea(
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
        ),
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
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
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
                        child: _StatCard(
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
                        child: _StatCard(
                          label: S.bookingsCount,
                          value: '${booked.length}',
                          icon: AppIcons.calendarCheck,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: _StatCard(
                          label: S.freeSlots,
                          value: '$free',
                          icon: AppIcons.calendarPlus,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _OccupancyMeter(slots: list),
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
                      FadeSlideIn(index: i, child: _HourRow(slot: s)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
    this.amount,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  /// When set, the number counts up from 0 (formatted as a price).
  final int? amount;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final fg = highlight ? Colors.white : AppColors.ink;
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlight ? null : AppColors.card,
        gradient: highlight
            ? LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [AppColors.primary, AppColors.primaryDark],
              )
            : null,
        borderRadius: BorderRadius.circular(18),
        border: highlight ? null : Border.all(color: AppColors.borderSoft),
        boxShadow: softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 16,
                  color: highlight ? Colors.white70 : AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: amount == null
                      ? Text(value,
                          style:
                              t.titleLarge?.copyWith(color: fg, fontSize: 16))
                      : CountUp(
                          value: amount!,
                          format: S.price,
                          style:
                              t.titleLarge?.copyWith(color: fg, fontSize: 16)),
                ),
              ),
            ],
          ),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.bodySmall?.copyWith(
                  color: highlight ? Colors.white70 : AppColors.inkMuted)),
        ],
      ),
    );
  }
}

/// One hour of today's timeline.
class _HourRow extends ConsumerWidget {
  const _HourRow({required this.slot});
  final TimeSlot slot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final b = slot.booking;
    final pending = b?.status == BookingStatus.pending;
    final state = slot.state;

    String title;
    String? subtitle;
    switch (state) {
      case SlotState.available:
        title = S.freeSlot;
      case SlotState.blocked:
        title = S.blocked;
        subtitle = slot.blockedSlot?.reason;
      case SlotState.manualBooked:
        title = b?.customerName ?? S.noName;
        subtitle =
            slot.isPast ? "${S.manualBooking} • ${S.ended}" : S.manualBooking;
      case SlotState.appBooked:
        final player = ref.watch(userProvider(b!.userId!)).valueOrNull;
        title = player?.name ?? '';
        subtitle = slot.isPast ? "${S.appBooking} • ${S.ended}" : S.appBooking;
    }

    final free = state == SlotState.available;
    final color = pending ? AppColors.pending : state.color;
    final tint = pending ? AppColors.warningLight : state.background;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        // Finished bookings stay readable; only past empty slots fade out.
        opacity: !slot.isPast
            ? 1
            : slot.booking != null
                ? .88
                : .4,
        child: PressableScale(
          child: Material(
            color: free ? AppColors.card.withOpacity(.55) : AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color: free ? AppColors.border : AppColors.borderSoft),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onOwnerSlotTap(context, ref, slot),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Colored edge shows the slot type at a glance.
                    Container(
                        width: 4, color: free ? Colors.transparent : color),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
                      child: SizedBox(
                        width: 54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Fmt.time(slot.startAt).split(' ').first,
                                style: t.titleMedium?.copyWith(height: 1.1)),
                            Text(Fmt.time(slot.startAt).split(' ').last,
                                style: t.bodySmall?.copyWith(height: 1.1)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: AppColors.borderSoft),
                    const SizedBox(width: 12),
                    Center(
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: free ? AppColors.primaryLight : tint,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(pending ? AppIcons.pending : state.icon,
                            size: 18, color: color),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.titleMedium?.copyWith(
                                    color: free
                                        ? AppColors.inkMuted
                                        : AppColors.ink)),
                            if (subtitle != null)
                              Text(subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.bodySmall?.copyWith(color: color)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: Center(
                        child: b == null
                            ? Icon(free ? AppIcons.forward : null,
                                size: 16, color: AppColors.inkFaint)
                            : pending
                                ? BookingStatusBadge(status: b.status)
                                : Text(S.price(b.price),
                                    style: t.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Today's occupancy: one animated bar split by booking type.
class _OccupancyMeter extends StatelessWidget {
  const _OccupancyMeter({required this.slots});
  final List<TimeSlot> slots;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();
    final t = Theme.of(context).textTheme;
    final total = slots.length;
    int count(SlotState s) => slots.where((x) => x.state == s).length;
    final app = count(SlotState.appBooked);
    final manual = count(SlotState.manualBooked);
    final blocked = count(SlotState.blocked);
    final used = app + manual + blocked;
    final percent = (used / total * 100).round();

    final parts = [
      (app, SlotState.appBooked.color),
      (manual, SlotState.manualBooked.color),
      (blocked, SlotState.blocked.color),
    ];

    return AppPanel(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(AppIcons.today, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.occupancyToday, style: t.titleMedium),
                    Text(S.bookedOf(used, total), style: t.bodySmall),
                  ],
                ),
              ),
              CountUp(
                value: percent,
                format: (v) => Fmt.ltr('$v%'),
                style: t.titleLarge?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Grows from empty to its value once when the screen opens.
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Motion.curve,
            builder: (_, v, __) => ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 10,
                child: Container(
                  color: AppColors.primaryLight,
                  child: Row(
                    children: [
                      for (final (n, color) in parts)
                        if (n > 0)
                          Expanded(
                            flex: (n * 1000 * v).round().clamp(1, 1 << 30),
                            child: Container(color: color),
                          ),
                      Expanded(
                        flex: ((total - used * v) * 1000)
                            .round()
                            .clamp(1, 1 << 30),
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              for (final s in [
                SlotState.appBooked,
                SlotState.manualBooked,
                SlotState.blocked
              ])
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration:
                          BoxDecoration(color: s.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text('${s.label} ${count(s)}', style: t.bodySmall),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
