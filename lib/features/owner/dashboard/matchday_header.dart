import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../../auth/session_controller.dart';
import 'pitch_switcher.dart';

/// Owner home header styled like a stadium scoreboard: greeting, date,
/// pitch (tap to switch) and a live strip with the next booking countdown.
class MatchdayHeader extends ConsumerWidget {
  const MatchdayHeader({super.key, required this.pitch, required this.slots});

  final Pitch pitch;

  /// Today's computed slots (null while loading).
  final List<TimeSlot>? slots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);
    final t = Theme.of(context).textTheme;
    final now = DateTime.now();
    final firstName = (user?.name ?? '').split(' ').take(2).join(' ');
    final greeting = now.hour < 12 ? S.goodMorning : S.goodEvening;

    return FadeSlideIn(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Pitch markings + a drifting ball as quiet decoration.
            const Positioned.fill(
                child: CustomPaint(painter: _HeaderLinesPainter())),
            const PositionedDirectional(
              end: -26,
              top: -18,
              child: FloatingBall(size: 130),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('$greeting، $firstName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(.85))),
                      ),
                      _GlassPill(
                          icon: AppIcons.calendar, text: Fmt.dayLong(now)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  PitchSwitcher(pitch: pitch, onDark: true),
                  const SizedBox(height: 12),
                  _NextBookingStrip(slots: slots),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.16),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.white),
            const SizedBox(width: 5),
            Text(text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

/// "Playing now" or "next booking in N minutes".
class _NextBookingStrip extends ConsumerWidget {
  const _NextBookingStrip({required this.slots});
  final List<TimeSlot>? slots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final now = DateTime.now();
    final booked = (slots ?? const <TimeSlot>[])
        .where((s) =>
            s.booking != null && s.booking!.status != BookingStatus.pending)
        .toList();
    final live = booked
        .where((s) => !s.startAt.isAfter(now) && s.endAt.isAfter(now))
        .firstOrNull;
    final next = booked.where((s) => s.startAt.isAfter(now)).firstOrNull;
    final slot = live ?? next;

    String? who;
    final b = slot?.booking;
    if (b != null) {
      who = b.source == BookingSource.manual
          ? (b.customerName ?? S.noName)
          : ref.watch(userProvider(b.userId!)).valueOrNull?.name;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedSwitcher(
        duration: Motion.normal,
        child: slot == null
            ? Row(
                key: const ValueKey('none'),
                children: [
                  Icon(AppIcons.confirmed,
                      size: 16, color: Colors.white.withOpacity(.85)),
                  const SizedBox(width: 8),
                  Text(S.noMoreBookingsToday,
                      style: t.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(.9),
                          fontWeight: FontWeight.w600)),
                ],
              )
            : Row(
                key: ValueKey(slot.startAt),
                children: [
                  PulseDot(
                    color: live != null
                        ? const Color(0xFFFF5A5A)
                        : const Color(0xFFB9F6CA),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(live != null ? S.playingNow : S.nextBooking,
                            style: t.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(.75),
                                height: 1.2)),
                        Text(
                          '${Fmt.time(slot.startAt)}${who == null ? '' : ' • $who'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.titleMedium
                              ?.copyWith(color: Colors.white, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  if (live == null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        S.inTime(slot.startAt.difference(now).inMinutes),
                        style: t.bodySmall?.copyWith(
                            color: const Color(0xFF0F5C26),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

/// Faint halfway line, centre circle and mowed stripes across the header.
class _HeaderLinesPainter extends CustomPainter {
  const _HeaderLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stripe = Paint()..color = Colors.white.withOpacity(.035);
    final w = size.width / 8;
    for (var i = 0; i < 8; i += 2) {
      canvas.drawRect(Rect.fromLTWH(i * w, 0, w, size.height), stripe);
    }
    final p = Paint()
      ..color = Colors.white.withOpacity(.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final cx = size.width * .3;
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), p);
    canvas.drawCircle(Offset(cx, size.height / 2), size.height * .42, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
