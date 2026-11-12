import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text(S.bookingDetails)),
      body: AsyncView(
        value: booking,
        builder: (b) {
          if (b == null) {
            return const EmptyState(
                icon: AppIcons.notFound, title: S.bookingNotFound);
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
              BookingStatusBanner(status: b.status),
              const SizedBox(height: 16),
              AppPanel(
                child: Column(
                  children: [
                    InfoRow(
                      icon: AppIcons.profile,
                      label: S.playerName,
                      value: isApp
                          ? (player?.name ?? '')
                          : (b.customerName ?? S.noName),
                    ),
                    if (isApp)
                      InfoRow(
                        icon: AppIcons.phone,
                        label: S.playerPhone,
                        value: phoneVisible && player != null
                            ? Fmt.phone(player.phone)
                            : S.phoneHiddenUntilConfirm,
                        valueColor: phoneVisible ? null : AppColors.inkFaint,
                      ),
                    InfoRow(
                      icon: isApp ? AppIcons.mobile : AppIcons.manual,
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
                          icon: AppIcons.pitch,
                          label: S.pitch,
                          value: pitch.name),
                    InfoRow(
                        icon: AppIcons.calendar,
                        label: S.date,
                        value: Fmt.dayLong(b.startAt)),
                    InfoRow(
                        icon: AppIcons.clock,
                        label: S.time,
                        value: Fmt.timeRange(b.startAt, b.endAt)),
                    InfoRow(
                        icon: AppIcons.money,
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
                  icon: AppIcons.call,
                  onPressed: () => showSnack(context, S.callMock),
                ),
              if (b.status == BookingStatus.pending) ...[
                PrimaryButton(
                  label: S.accept,
                  icon: AppIcons.check,
                  onPressed: () => answerRequest(context, ref, b, accept: true),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: S.reject,
                  icon: AppIcons.close,
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
