import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../../auth/session_controller.dart';
import '../player_providers.dart';

/// Player home header: greeting, question, and the player's next match
/// (live / countdown) — or a nudge to book when nothing is coming up.
class PlayerHeroHeader extends ConsumerWidget {
  const PlayerHeroHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);
    final next = ref.watch(nextMatchProvider).valueOrNull;
    final t = Theme.of(context).textTheme;
    final firstName = (user?.name ?? '').split(' ').first;

    return HeroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroGreeting(name: firstName),
          const SizedBox(height: 4),
          Text(S.homeQuestion,
              style: t.headlineMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          next == null
              ? HeroStrip(
                  onTap: () => context.go(Routes.playerSearch),
                  child: HeroStripMessage(
                    icon: AppIcons.ball,
                    text: S.noUpcomingMatch,
                    action: Icon(AppIcons.forward,
                        size: 16, color: Colors.white.withOpacity(.9)),
                  ),
                )
              : _NextMatchStrip(booking: next),
        ],
      ),
    );
  }
}

class _NextMatchStrip extends ConsumerWidget {
  const _NextMatchStrip({required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(pitchProvider(booking.pitchId)).valueOrNull;
    final now = DateTime.now();
    final live = !booking.startAt.isAfter(now) && booking.endAt.isAfter(now);
    final minutes = booking.startAt.difference(now).inMinutes;
    final soon = !live && minutes < 24 * 60;
    final pending = booking.status == BookingStatus.pending;

    return HeroStrip(
      onTap: () => context.push(Routes.playerBooking(booking.id)),
      child: HeroStripBooking(
        live: live,
        label: live
            ? S.playingNow
            : pending
                ? '${S.yourNextMatch} • ${S.awaitingConfirmation}'
                : S.yourNextMatch,
        title:
            '${pitch?.name ?? ''} • ${Fmt.isSameDay(booking.startAt, now) ? '' : '${Fmt.dayRelative(booking.startAt)} '}${Fmt.time(booking.startAt)}',
        countdown: soon ? S.inTime(minutes) : null,
      ),
    );
  }
}

/// Horizontal strip: the earliest free slot today at nearby pitches.
class AvailableTodayStrip extends ConsumerWidget {
  const AvailableTodayStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(availableTodayProvider).valueOrNull;
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            PulseDot(color: AppColors.primary, size: 7),
            const SizedBox(width: 4),
            Text(S.availableToday, style: t.titleLarge),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final (pitch, slot) = items[i];
              return FadeSlideIn(
                index: i,
                child: PressableScale(
                  child: _SlotCard(
                    pitch: pitch,
                    slot: slot,
                    onTap: () {
                      ref.read(selectedDateProvider.notifier).state =
                          Fmt.dateOnly(slot.startAt);
                      context.push(Routes.pitchSlots(pitch.id));
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard(
      {required this.pitch, required this.slot, required this.onTap});
  final Pitch pitch;
  final TimeSlot slot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: 150,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  PitchImage(
                    photoKey:
                        pitch.photos.isEmpty ? pitch.id : pitch.photos.first,
                    height: 72,
                  ),
                  PositionedDirectional(
                    bottom: 6,
                    start: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(AppIcons.clock,
                              size: 12, color: AppColors.onPhotoInk),
                          const SizedBox(width: 3),
                          Text(Fmt.time(slot.startAt),
                              style: t.bodySmall?.copyWith(
                                  color: AppColors.onPhotoInk,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pitch.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.titleMedium),
                    Text(S.price(slot.price),
                        style: t.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
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

/// Chips for pitches the player has played at before.
class BookAgainRow extends ConsumerWidget {
  const BookAgainRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitches = ref.watch(bookAgainProvider).valueOrNull;
    if (pitches == null || pitches.isEmpty) return const SizedBox.shrink();
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.bookAgain, style: t.titleLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (i, p) in pitches.indexed)
              FadeSlideIn(
                index: i,
                child: PressableScale(
                  child: Material(
                    color: AppColors.card,
                    shape: StadiumBorder(
                        side: BorderSide(color: AppColors.borderSoft)),
                    child: InkWell(
                      customBorder: const StadiumBorder(),
                      onTap: () => context.push(Routes.pitchSlots(p.id)),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 5, 12, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: PitchImage(
                                photoKey:
                                    p.photos.isEmpty ? p.id : p.photos.first,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(p.name,
                                style: t.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 4),
                            Icon(AppIcons.history,
                                size: 14, color: AppColors.inkMuted),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
