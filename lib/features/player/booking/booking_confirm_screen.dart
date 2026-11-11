import 'package:flutter/material.dart';
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
import '../../../data/repositories/repositories.dart';
import '../../auth/session_controller.dart';

class BookingConfirmScreen extends ConsumerStatefulWidget {
  const BookingConfirmScreen({super.key, required this.slot});
  final TimeSlot slot;

  @override
  ConsumerState<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  bool _loading = false;

  Future<void> _book() async {
    setState(() => _loading = true);
    try {
      final booking = await ref.read(bookingRepositoryProvider).createBooking(
            pitchId: widget.slot.pitchId,
            userId: ref.read(currentUserIdProvider),
            startAt: widget.slot.startAt,
            endAt: widget.slot.endAt,
            source: BookingSource.app,
          );
      ref.refreshData();
      if (mounted) context.go(Routes.bookingSuccess(booking.id));
    } on SlotUnavailableException {
      ref.refreshData();
      if (!mounted) return;
      showSnack(context, S.slotJustTaken);
      context.pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.slot;
    final pitch = ref.watch(pitchProvider(slot.pitchId)).valueOrNull;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(S.confirmBooking)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (pitch != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  PitchImage(
                      photoKey:
                          pitch.photos.isEmpty ? pitch.id : pitch.photos.first,
                      height: 120),
                  PositionedDirectional(
                    bottom: 12,
                    start: 16,
                    child: Text(pitch.name,
                        style: t.titleLarge?.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text(S.bookingSummary, style: t.titleLarge),
          const SizedBox(height: 8),
          AppPanel(
            child: Column(
              children: [
                if (pitch != null)
                  InfoRow(
                      icon: AppIcons.location,
                      label: S.pitch,
                      value: '${pitch.name} - ${pitch.area}'),
                InfoRow(
                    icon: AppIcons.calendar,
                    label: S.date,
                    value: Fmt.dayRelative(slot.startAt)),
                InfoRow(
                    icon: AppIcons.clock,
                    label: S.time,
                    value: Fmt.timeRange(slot.startAt, slot.endAt)),
                InfoRow(
                    icon: AppIcons.duration,
                    label: S.duration,
                    value: Fmt.duration(slot.duration)),
                const Divider(height: 24),
                InfoRow(
                    icon: AppIcons.money,
                    label: S.total,
                    value: S.price(slot.price),
                    valueColor: AppColors.primary),
                Text(S.paymentAtPitch,
                    style: t.bodySmall, textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppPanel(
            color: AppColors.warningLight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(AppIcons.policy, color: AppColors.pending),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.cancellationPolicy,
                          style: t.titleMedium
                              ?.copyWith(color: AppColors.pending)),
                      const SizedBox(height: 4),
                      Text(S.cancellationPolicyText,
                          style: t.bodyMedium?.copyWith(height: 1.6)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(AppIcons.info, size: 20, color: AppColors.inkMuted),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(S.requestNote,
                      style:
                          t.bodyMedium?.copyWith(color: AppColors.inkMuted))),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          label: S.sendBookingRequest,
          icon: AppIcons.check,
          loading: _loading,
          onPressed: _book,
        ),
      ),
    );
  }
}
