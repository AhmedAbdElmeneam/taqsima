import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

/// Short, calm motion used across the app. Durations stay under ~400ms so the
/// app feels quick for owners checking bookings in a hurry.
abstract final class Motion {
  static const fast = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 320);
  static const curve = Curves.easeOutCubic;
}

/// List items fade in and rise slightly, one after another.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;

  /// Position in the list; later items start a little later (capped).
  final int index;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: Motion.normal);
  late final _anim = CurvedAnimation(parent: _c, curve: Motion.curve);

  @override
  void initState() {
    super.initState();
    final delay = Duration(milliseconds: 45 * math.min(widget.index, 8));
    Future.delayed(delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: SlideTransition(
        position:
            Tween(begin: const Offset(0, .06), end: Offset.zero).animate(_anim),
        child: widget.child,
      ),
    );
  }
}

/// A football that spins and gently bounces — the app's loading indicator.
class BallLoader extends StatefulWidget {
  const BallLoader({super.key, this.size = 30});
  final double size;

  @override
  State<BallLoader> createState() => _BallLoaderState();
}

class _BallLoaderState extends State<BallLoader>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 1.6,
      height: widget.size * 1.8,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, child) {
          final t = _c.value;
          // Bounce: up and down once per turn.
          final y = -math.sin(t * math.pi).abs() * widget.size * .45;
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Shadow shrinks while the ball is in the air.
              Container(
                width: widget.size * (.9 - .35 * math.sin(t * math.pi)),
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.ink.withOpacity(.12),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Transform.translate(
                offset: Offset(0, y - 6),
                child: Transform.rotate(angle: t * 2 * math.pi, child: child),
              ),
            ],
          );
        },
        child: Icon(AppIcons.ball, size: widget.size, color: AppColors.primary),
      ),
    );
  }
}

/// Counts a number up from 0 when first shown (e.g. today's revenue).
class CountUp extends StatelessWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.format,
    this.style,
  });

  final int value;
  final String Function(int) format;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 750),
      curve: Motion.curve,
      builder: (_, v, __) => Text(format(v.round()), style: style),
    );
  }
}
