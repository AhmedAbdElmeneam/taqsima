import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../requests/booking_requests_screen.dart';

/// Owner view of a booking. The player's phone is shown ONLY once confirmed.
class OwnerBookingDetailsScreen extends ConsumerWidget {
  const OwnerBookingDetailsScreen({super.key, required this.bookingId});
  final String bookingId;

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
          final isApp = b.source == BookingSource.app;
          final player =
              isApp ? ref.watch(userProvider(b.userId!)).valueOrNull : null;
          final pitch = ref.watch(pitchProvider(b.pitchId)).valueOrNull;
          final phoneVisible = isApp &&
              (b.status == BookingStatus.confirmed ||
                  b.status == BookingStatus.completed);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AppPanel(
                color: b.status.background,
                child: Row(
                  children: [
                    Icon(b.status.icon, color: b.status.color, size: 32),
                    const SizedBox(width: 12),
                    Text(b.status.label,
                        style: t.titleLarge?.copyWith(color: b.status.color)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppPanel(
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: S.playerName,
                      value: isApp
                          ? (player?.name ?? '')
                          : (b.customerName ?? S.noName),
                    ),
                    if (isApp)
                      InfoRow(
                        icon: Icons.phone_outlined,
                        label: S.playerPhone,
                        value: phoneVisible && player != null
                            ? Fmt.phone(player.phone)
                            : S.phoneHiddenUntilConfirm,
                        valueColor: phoneVisible ? null : AppColors.inkFaint,
                      ),
                    InfoRow(
                      icon: isApp
                          ? Icons.smartphone_rounded
                          : Icons.edit_note_rounded,
                      label: S.source,
                      value: isApp ? S.sourceApp : S.sourceManual,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppPanel(
                child: Column(
                  children: [
                    if (pitch != null)
                      InfoRow(
                          icon: Icons.stadium_outlined,
                          label: S.pitch,
                          value: pitch.name),
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
              if (phoneVisible)
                PrimaryButton(
                  label: S.call,
                  icon: Icons.call_rounded,
                  onPressed: () => showSnack(context, S.callMock),
                ),
              if (b.status == BookingStatus.pending) ...[
                PrimaryButton(
                  label: S.accept,
                  icon: Icons.check_rounded,
                  onPressed: () => answerRequest(context, ref, b, accept: true),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: S.reject,
                  icon: Icons.close_rounded,
                  color: AppColors.error,
                  onPressed: () =>
                      answerRequest(context, ref, b, accept: false),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
