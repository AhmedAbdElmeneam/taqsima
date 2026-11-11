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

    final free = state == SlotState.available;
    final color = pending ? AppColors.slotManual : state.color;
    final tint = pending ? AppColors.warningLight : state.background;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: slot.isPast ? .45 : 1,
        child: Material(
          color: free ? AppColors.surface.withOpacity(.6) : AppColors.surface,
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
                  Container(width: 4, color: free ? Colors.transparent : color),
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
                                  style: t.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
