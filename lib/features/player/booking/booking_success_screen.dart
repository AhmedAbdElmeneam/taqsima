import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers.dart';

class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider(bookingId)).valueOrNull;
    final pitch = booking == null
        ? null
        : ref.watch(pitchProvider(booking.pitchId)).valueOrNull;
    final t = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) context.go(Routes.playerHome);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                // Check pops in with a short celebratory burst behind it.
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const ConfettiBurst(size: 240),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      builder: (_, v, child) =>
                          Transform.scale(scale: v, child: child),
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(AppIcons.check,
                            size: 52, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(S.bookingSent,
                    style: t.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(S.bookingSentHint,
                    style: t.bodyLarge?.copyWith(color: AppColors.inkMuted),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                if (booking != null && pitch != null)
                  AppPanel(
                    child: Column(
                      children: [
                        Text(pitch.name, style: t.titleLarge),
                        const SizedBox(height: 4),
                        Text(
                          '${Fmt.dayRelative(booking.startAt)} • ${Fmt.timeRange(booking.startAt, booking.endAt)}',
                          style: t.bodyLarge,
                        ),
                        const SizedBox(height: 10),
                        BookingStatusBadge(status: booking.status),
                      ],
                    ),
                  ),
                const Spacer(),
                PrimaryButton(
                  label: S.viewBooking,
                  onPressed: () => context.go(Routes.playerBooking(bookingId)),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: S.backToHome,
                  onPressed: () => context.go(Routes.playerHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
