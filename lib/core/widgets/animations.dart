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

/// A small dot that softly pulses — used for "live" / "now" indicators.
class PulseDot extends StatefulWidget {
  const PulseDot({super.key, required this.color, this.size = 8});
  final Color color;
  final double size;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return SizedBox(
      width: s * 2.6,
      height: s * 2.6,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [
            // Expanding ring.
            Container(
              width: s + s * 1.6 * _c.value,
              height: s + s * 1.6 * _c.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(.35 * (1 - _c.value)),
              ),
            ),
            Container(
              width: s,
              height: s,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: widget.color),
            ),
          ],
        ),
      ),
    );
  }
}

/// A large decorative football that slowly drifts and turns.
class FloatingBall extends StatefulWidget {
  const FloatingBall({super.key, this.size = 120, this.color});
  final double size;
  final Color? color;

  @override
  State<FloatingBall> createState() => _FloatingBallState();
}

class _FloatingBallState extends State<FloatingBall>
    with SingleTickerProviderStateMixin {
  late final _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 9))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, math.sin(_c.value * 2 * math.pi) * 6),
        child: Transform.rotate(angle: _c.value * 2 * math.pi, child: child),
      ),
      child: Icon(AppIcons.ball,
          size: widget.size,
          color: widget.color ?? Colors.white.withOpacity(.14)),
    );
  }
}

/// Shrinks slightly while pressed — tactile feedback for tappable cards.
class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child, this.scale = .97});
  final Widget child;
  final double scale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: Motion.fast,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// A one-time burst of small green and white dots (booking success).
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key, this.size = 220});
  final double size;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1100))
    ..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => CustomPaint(
            painter: _ConfettiPainter(
                Curves.easeOutCubic.transform(_c.value), AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.green);
  final double t;
  final Color green;

  @override
  void paint(Canvas canvas, Size size) {
    if (t == 0) return;
    final c = size.center(Offset.zero);
    final rnd = math.Random(7);
    for (var i = 0; i < 22; i++) {
      final angle = i / 22 * 2 * math.pi + rnd.nextDouble() * .3;
      final dist = size.width * (.22 + .28 * t) * (.8 + rnd.nextDouble() * .4);
      final p = c + Offset(math.cos(angle), math.sin(angle)) * dist;
      final color = (i.isEven ? green : const Color(0xFFF2C94C))
          .withOpacity((1 - t).clamp(0, 1));
      canvas.drawCircle(p, 3.5 * (1 - t * .5), Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
