import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/labels.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../../data/providers.dart';
import '../../calendar/slot_action_sheet.dart';

/// One hour of today's timeline.
class TodaySlotRow extends ConsumerWidget {
  const TodaySlotRow({super.key, required this.slot});
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
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
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
