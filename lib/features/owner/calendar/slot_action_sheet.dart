import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_icons.dart';
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
import '../../../data/repositories/repositories.dart';

/// Owner taps any slot (dashboard or calendar):
/// - free → block it or record a manual booking (optional customer name)
/// - blocked → unblock
/// - manual booking → view / remove
/// - app booking → open booking details
Future<void> onOwnerSlotTap(
    BuildContext context, WidgetRef ref, TimeSlot slot) async {
  if (slot.state == SlotState.appBooked && slot.booking != null) {
    context.push(Routes.ownerBooking(slot.booking!.id));
    return;
  }
  // Finished bookings: just show the details.
  if (slot.isPast && slot.booking != null) {
    context.push(Routes.ownerBooking(slot.booking!.id));
    return;
  }
  if (slot.isPast) return;
  await showAppBottomSheet<void>(
    context,
    title:
        '${Fmt.dayRelative(slot.startAt)} • ${Fmt.timeRange(slot.startAt, slot.endAt)}',
    builder: (_) => _SlotActionSheet(slot: slot),
  );
}

enum _Mode { choose, block, manual }

class _SlotActionSheet extends ConsumerStatefulWidget {
  const _SlotActionSheet({required this.slot});
  final TimeSlot slot;

  @override
  ConsumerState<_SlotActionSheet> createState() => _SlotActionSheetState();
}

class _SlotActionSheetState extends ConsumerState<_SlotActionSheet> {
  final _text = TextEditingController();
  _Mode _mode = _Mode.choose;
  bool _loading = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function(BookingRepository repo) action,
      String doneMessage) async {
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      await action(ref.read(bookingRepositoryProvider));
      ref.refreshData();
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(doneMessage)));
    } on SlotUnavailableException {
      ref.refreshData();
      nav.pop();
      messenger.showSnackBar(const SnackBar(content: Text(S.slotJustTaken)));
    }
  }

  String? get _value => _text.text.trim().isEmpty ? null : _text.text.trim();

  @override
  Widget build(BuildContext context) {
    final s = widget.slot;
    final t = Theme.of(context).textTheme;

    switch (s.state) {
      case SlotState.blocked:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StateHeader(
                state: s.state, text: s.blockedSlot?.reason ?? S.blocked),
            const SizedBox(height: 20),
            PrimaryButton(
              label: S.unblock,
              icon: AppIcons.unlock,
              loading: _loading,
              onPressed: () => _run(
                  (r) => r.unblockSlot(s.blockedSlot!.id), S.slotUnblocked),
            ),
          ],
        );
      case SlotState.manualBooked:
        final b = s.booking!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StateHeader(state: s.state, text: b.customerName ?? S.noName),
            const SizedBox(height: 20),
            PrimaryButton(
              label: S.viewDetails,
              onPressed: () {
                Navigator.pop(context);
                context.push(Routes.ownerBooking(b.id));
              },
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: S.removeManualBooking,
              icon: AppIcons.delete,
              color: AppColors.error,
              onPressed: _loading
                  ? null
                  : () => _run(
                      (r) => r.deleteBooking(b.id), S.manualBookingRemoved),
            ),
          ],
        );
      case SlotState.appBooked:
        return const SizedBox.shrink();
      case SlotState.available:
        break;
    }

    if (_mode == _Mode.choose) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.slotActions,
              style: t.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 14),
          _OptionTile(
            icon: AppIcons.manual,
            color: AppColors.slotManual,
            background: AppColors.slotManualBg,
            title: S.addManualBooking,
            subtitle: S.addManualBookingHint,
            onTap: () => setState(() => _mode = _Mode.manual),
          ),
          const SizedBox(height: 10),
          _OptionTile(
            icon: AppIcons.lock,
            color: AppColors.slotBlocked,
            background: AppColors.slotBlockedBg,
            title: S.blockSlot,
            subtitle: S.blockSlotHint,
            onTap: () => setState(() => _mode = _Mode.block),
          ),
        ],
      );
    }

    final manual = _mode == _Mode.manual;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: manual ? S.customerName : S.blockReason,
          hint: manual ? S.customerNameHint : S.blockReasonHint,
          controller: _text,
          autofocus: true,
          prefixIcon: manual ? AppIcons.profile : AppIcons.note,
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: manual ? S.addManualBooking : S.blockSlot,
          icon: manual ? AppIcons.check : AppIcons.lock,
          color: manual ? null : AppColors.ink,
          loading: _loading,
          onPressed: () => manual
              ? _run(
                  (r) => r.createBooking(
                        pitchId: s.pitchId,
                        userId: null,
                        startAt: s.startAt,
                        endAt: s.endAt,
                        source: BookingSource.manual,
                        customerName: _value,
                      ),
                  S.manualBookingAdded)
              : _run(
                  (r) => r.blockSlot(
                        pitchId: s.pitchId,
                        startAt: s.startAt,
                        endAt: s.endAt,
                        reason: _value,
                      ),
                  S.slotBlocked),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _mode = _Mode.choose),
          child: const Text(S.back),
        ),
      ],
    );
  }
}

class _StateHeader extends StatelessWidget {
  const _StateHeader({required this.state, required this.text});
  final SlotState state;
  final String text;

  @override
  Widget build(BuildContext context) => AppPanel(
        color: state.background,
        child: Row(
          children: [
            Icon(state.icon, color: state.color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: state.color, fontWeight: FontWeight.w700)),
                  Text(text, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ],
        ),
      );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: AppColors.border, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(AppSpacing.radius)),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: t.titleMedium),
                    Text(subtitle,
                        style:
                            t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
