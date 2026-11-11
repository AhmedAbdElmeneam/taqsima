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
import '../player_providers.dart';

/// Player view of a booking. The owner's phone number is never shown here.
class PlayerBookingDetailsScreen extends ConsumerWidget {
  const PlayerBookingDetailsScreen({super.key, required this.bookingId});
  final String bookingId;

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmSheet(
      context,
      title: S.cancelBookingQ,
      message: S.cancellationPolicyText,
      confirmLabel: S.yesCancel,
      cancelLabel: S.noKeep,
      destructive: true,
    );
    if (!ok) return;
    await ref
        .read(bookingRepositoryProvider)
        .updateStatus(bookingId, BookingStatus.cancelled);
    ref.refreshData();
    if (context.mounted) showSnack(context, S.bookingCancelled);
  }

  Future<void> _report(BuildContext context) async {
    final controller = TextEditingController();
    final sent = await showAppBottomSheet<bool>(
      context,
      title: S.reportProblem,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: controller,
            hint: S.reportProblemHint,
            maxLines: 4,
            autofocus: true,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: S.send,
            icon: Icons.send_rounded,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    if (sent == true && context.mounted) showSnack(context, S.reportSent);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider(bookingId));
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(S.bookingDetails)),
      body: AsyncView(
        value: booking,
        builder: (b) {
          if (b == null) {
            return const EmptyState(
                icon: Icons.search_off_rounded, title: S.bookingNotFound);
          }
          final pitch = ref.watch(pitchProvider(b.pitchId)).valueOrNull;
          final active = b.status == BookingStatus.pending ||
              b.status == BookingStatus.confirmed;
          final cancellable = canCancel(b);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AppPanel(
                color: b.status.background,
                child: Row(
                  children: [
                    Icon(b.status.icon, color: b.status.color, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.status.label,
                              style: t.titleLarge
                                  ?.copyWith(color: b.status.color)),
                          if (b.status == BookingStatus.pending)
                            Text(S.requestNote, style: t.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (pitch != null)
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.push(Routes.pitch(pitch.id)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PitchImage(
                            photoKey: pitch.photos.isEmpty
                                ? pitch.id
                                : pitch.photos.first,
                            height: 110),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pitch.name, style: t.titleMedium),
                                    Text(pitch.area,
                                        style: t.bodyMedium?.copyWith(
                                            color: AppColors.inkMuted)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_left_rounded,
                                  color: AppColors.inkFaint),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              AppPanel(
                child: Column(
                  children: [
                    InfoRow(
                        icon: Icons.confirmation_number_outlined,
                        label: S.bookingNumber,
                        value: '#${b.id.toUpperCase()}'),
                    InfoRow(
                        icon: Icons.calendar_today_rounded,
                        label: S.date,
                        value: Fmt.dayLong(b.startAt)),
                    InfoRow(
                        icon: Icons.schedule_rounded,
                        label: S.time,
                        value: Fmt.timeRange(b.startAt, b.endAt)),
                    InfoRow(
                        icon: Icons.payments_outlined,
                        label: S.total,
                        value: S.price(b.price),
                        valueColor: AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (pitch != null)
                PrimaryButton(
                  label: S.directions,
                  icon: Icons.directions_rounded,
                  onPressed: () => showSnack(context, S.directionsMock),
                ),
              if (active) ...[
                const SizedBox(height: 10),
                SecondaryButton(
                  label: S.cancelBooking,
                  icon: Icons.close_rounded,
                  color: AppColors.error,
                  onPressed: cancellable ? () => _cancel(context, ref) : null,
                ),
                if (!cancellable)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(S.cancelNotAllowed,
                        style: t.bodySmall, textAlign: TextAlign.center),
                  ),
              ],
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => _report(context),
                icon:
                    const Icon(Icons.flag_outlined, color: AppColors.inkMuted),
                label: Text(S.reportProblem,
                    style: t.titleMedium?.copyWith(color: AppColors.inkMuted)),
              ),
            ],
          );
        },
      ),
    );
  }
}
