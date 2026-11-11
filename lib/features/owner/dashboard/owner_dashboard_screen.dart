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
import '../../auth/session_controller.dart';
import '../calendar/slot_action_sheet.dart';
import '../owner_providers.dart';
import 'pitch_switcher.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(currentOwnerPitchProvider);
    return Scaffold(
      body: SafeArea(
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
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard({required this.pitch});
  final Pitch pitch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);
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
          Text(
              '${S.hello((user?.name ?? '').split(' ').take(2).join(' '))} • ${Fmt.dayLong(today)}',
              style: t.bodySmall),
          PitchSwitcher(pitch: pitch),
          const SizedBox(height: 12),
          if (pitch.status == PitchStatus.pending) ...[
            AppPanel(
              color: AppColors.warningLight,
              child: Row(
                children: [
                  const Icon(AppIcons.clock, color: AppColors.slotManual),
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
                      const Icon(AppIcons.bellRinging,
                          color: AppColors.info, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(S.pendingRequestsBanner(requests.length),
                            style:
                                t.titleMedium?.copyWith(color: AppColors.info)),
                      ),
                      const Icon(AppIcons.forward,
                          color: AppColors.info, size: 18),
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
                    for (final s in list) _HourRow(slot: s),
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
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final fg = highlight ? Colors.white : AppColors.ink;
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlight ? null : AppColors.surface,
        gradient: highlight
            ? const LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [Color(0xFF22A049), AppColors.primaryDark],
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
                  child: Text(value,
                      style: t.titleLarge?.copyWith(color: fg, fontSize: 16)),
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
        subtitle = S.manualBooking;
      case SlotState.appBooked:
        final player = ref.watch(userProvider(b!.userId!)).valueOrNull;
        title = player?.name ?? '';
        subtitle = S.appBooking;
    }

    final color = pending ? AppColors.slotManual : state.color;
    final bg =
        state == SlotState.available ? AppColors.surface : state.background;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: slot.isPast ? .5 : 1,
        child: Row(
          children: [
            SizedBox(
              width: 62,
              child: Text(Fmt.time(slot.startAt),
                  style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: Material(
                color: bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: state == SlotState.available
                        ? AppColors.borderSoft
                        : Colors.transparent,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onOwnerSlotTap(context, ref, slot),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          Icon(state.icon, color: color, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(title,
                                    style: t.titleMedium?.copyWith(
                                        color: state == SlotState.available
                                            ? AppColors.inkMuted
                                            : AppColors.ink)),
                                if (subtitle != null)
                                  Text(subtitle,
                                      style:
                                          t.bodySmall?.copyWith(color: color)),
                              ],
                            ),
                          ),
                          if (b != null) ...[
                            if (pending)
                              BookingStatusBadge(status: b.status)
                            else
                              Text(S.price(b.price),
                                  style: t.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
