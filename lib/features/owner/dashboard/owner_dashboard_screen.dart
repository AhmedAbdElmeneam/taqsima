import 'package:flutter/material.dart';
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
                  icon: Icons.stadium_outlined,
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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(S.hello((user?.name ?? '').split(' ').take(2).join(' ')),
              style: t.bodyLarge?.copyWith(color: AppColors.inkMuted)),
          PitchSwitcher(pitch: pitch),
          Text(Fmt.dayLong(today), style: t.bodyMedium),
          const SizedBox(height: 14),
          if (pitch.status == PitchStatus.pending) ...[
            AppPanel(
              color: AppColors.warningLight,
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      color: AppColors.slotManual),
                  const SizedBox(width: 10),
                  Expanded(child: Text(S.underReviewHint, style: t.bodyMedium)),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (requests.isNotEmpty) ...[
            Material(
              color: AppColors.info,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => context.go(Routes.ownerRequests),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active_rounded,
                          color: Colors.white, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(S.pendingRequestsBanner(requests.length),
                            style:
                                t.titleMedium?.copyWith(color: Colors.white)),
                      ),
                      Text(S.review,
                          style: t.titleMedium?.copyWith(color: Colors.white)),
                      const Icon(Icons.chevron_left_rounded,
                          color: Colors.white),
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
                          icon: Icons.payments_rounded,
                          highlight: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: _StatCard(
                          label: S.bookingsCount,
                          value: '${booked.length}',
                          icon: Icons.event_available_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: _StatCard(
                          label: S.freeSlots,
                          value: '$free',
                          icon: Icons.event_seat_outlined,
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
                      icon: Icons.door_front_door_outlined,
                      title: S.closedThisDay,
                    )
                  else
                    for (final s in list) _HourRow(slot: s),
                  const SizedBox(height: 20),
                  Text(S.quickActions, style: t.titleLarge),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.schedule_rounded,
                          label: S.workingHours,
                          onTap: () =>
                              context.push(Routes.ownerHours(pitch.id)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.edit_outlined,
                          label: S.editPitch,
                          onTap: () =>
                              context.push(Routes.ownerEditPitch(pitch.id)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.add_business_outlined,
                          label: S.addPitch,
                          onTap: () => context.push(Routes.ownerPitchForm),
                        ),
                      ),
                    ],
                  ),
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
      height: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: highlight ? null : Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: highlight ? Colors.white : AppColors.primary),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(value,
                style: t.headlineMedium?.copyWith(color: fg, fontSize: 24)),
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
              width: 70,
              child: Text(Fmt.time(slot.startAt),
                  style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: Material(
                color: bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: state == SlotState.available
                        ? AppColors.border
                        : Colors.transparent,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onOwnerSlotTap(context, ref, slot),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 56),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(state.icon, color: color),
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

class _QuickAction extends StatelessWidget {
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
            child: Column(
              children: [
                Icon(icon, color: AppColors.primary, size: 30),
                const SizedBox(height: 6),
                Text(label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
}
