import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../utils/formatters.dart';
import 'animations.dart';

/// Green "matchday" card used at the top of both home screens: gradient,
/// faint pitch markings, a slowly drifting ball, and an entrance animation.
class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            const Positioned.fill(
                child: CustomPaint(painter: _HeroLinesPainter())),
            const PositionedDirectional(
              end: -26,
              top: -18,
              child: FloatingBall(size: 130),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Small frosted pill for use on the green card (e.g. the date).
class GlassPill extends StatelessWidget {
  const GlassPill({super.key, required this.icon, required this.text});
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

/// Darker strip inside the green card (live / next booking line).
class HeroStrip extends StatelessWidget {
  const HeroStrip({super.key, required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black.withOpacity(.16),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: AnimatedSize(duration: Motion.normal, child: child),
          ),
        ),
      );
}

/// White countdown chip ("بعد 25 دقيقة").
class CountdownChip extends StatelessWidget {
  const CountdownChip({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF0F5C26), fontWeight: FontWeight.w800)),
      );
}

/// Faint halfway line, centre circle and mowed stripes across the card.
class _HeroLinesPainter extends CustomPainter {
  const _HeroLinesPainter();

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

/// "صباح الخير، أحمد" + today's date pill.
class HeroGreeting extends StatelessWidget {
  const HeroGreeting({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = now.hour < 12 ? S.goodMorning : S.goodEvening;
    return Row(
      children: [
        Expanded(
          child: Text('$greeting، $name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white.withOpacity(.85))),
        ),
        GlassPill(icon: AppIcons.calendar, text: Fmt.dayLong(now)),
      ],
    );
  }
}

/// Simple icon + sentence line inside a [HeroStrip].
class HeroStripMessage extends StatelessWidget {
  const HeroStripMessage(
      {super.key, required this.icon, required this.text, this.action});
  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 16, color: Colors.white.withOpacity(.85)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(.9),
                    fontWeight: FontWeight.w600)),
          ),
          if (action != null) action!,
        ],
      );
}

/// Live/next booking line: pulsing dot, label, title and countdown chip.
class HeroStripBooking extends StatelessWidget {
  const HeroStripBooking({
    super.key,
    required this.live,
    required this.label,
    required this.title,
    this.countdown,
    this.trailing,
  });

  final bool live;
  final String label;
  final String title;
  final String? countdown;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        PulseDot(
            color: live ? const Color(0xFFFF5A5A) : const Color(0xFFB9F6CA)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: t.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(.75), height: 1.2)),
              Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleMedium
                      ?.copyWith(color: Colors.white, height: 1.3)),
            ],
          ),
        ),
        if (countdown != null) CountdownChip(text: countdown!),
        if (trailing != null) trailing!,
      ],
    );
  }
}
