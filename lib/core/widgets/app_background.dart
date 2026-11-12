import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_colors.dart';

/// App-wide background, themed on a football pitch seen from above:
/// mowed-grass stripes, faint field markings (halfway line, centre circle,
/// penalty box) and — in dark mode — two floodlight glows like a night match.
/// Every Scaffold is transparent on top of it.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
              painter: _PitchBackgroundPainter(dark: AppColors.isDark)),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _PitchBackgroundPainter extends CustomPainter {
  const _PitchBackgroundPainter({required this.dark});
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;
    final green = dark ? const Color(0xFF2E7D4F) : const Color(0xFF1B8A3A);

    // 1. Base: grass-tinted wash over the whole screen.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? const [Color(0xFF10251A), Color(0xFF0D1913), Color(0xFF0F2117)]
              : const [Color(0xFFDDF0E2), Color(0xFFEDF5EF), Color(0xFFE2F1E6)],
          stops: const [0, .5, 1],
        ).createShader(rect),
    );

    // 2. Mowed-grass stripes from top to bottom.
    final stripeH = h / 14;
    final stripe = Paint()..color = green.withOpacity(dark ? .075 : .05);
    for (var i = 0; i < 14; i += 2) {
      canvas.drawRect(Rect.fromLTWH(0, i * stripeH, w, stripeH), stripe);
    }

    // 3. Light: floodlights at night, soft daylight glow by day.
    void glow(Offset c, double r, Color color) => canvas.drawCircle(
          c,
          r,
          Paint()
            ..shader = RadialGradient(colors: [color, color.withOpacity(0)])
                .createShader(Rect.fromCircle(center: c, radius: r)),
        );
    if (dark) {
      glow(Offset(-w * .05, -h * .02), w * .9,
          const Color(0xFFBFF5D2).withOpacity(.10));
      glow(Offset(w * 1.05, -h * .02), w * .9,
          const Color(0xFFBFF5D2).withOpacity(.10));
      glow(Offset(w * .5, h * 1.05), w * .8,
          const Color(0xFFBFF5D2).withOpacity(.05));
    } else {
      glow(Offset(w * .85, h * .05), w * .8, Colors.white.withOpacity(.55));
      glow(Offset(w * .1, h * .7), w * .7, Colors.white.withOpacity(.35));
    }

    // 4. A full pitch, top to bottom of the screen.
    final line = Paint()
      ..color = (dark ? Colors.white : green).withOpacity(dark ? .08 : .11)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    final dot = Paint()..color = line.color;
    // Touchlines sit at the very edge of the screen, outside the 20px content
    // padding, so they never run through cards or text.
    final field = Rect.fromLTRB(w * .012, h * .01, w * .988, h * .99);
    final cx = field.center.dx;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            field, const Radius.circular(AppSpacing.radiusXs)),
        line);
    // Halfway line + centre circle.
    canvas.drawLine(Offset(field.left, field.center.dy),
        Offset(field.right, field.center.dy), line);
    canvas.drawCircle(field.center, w * .22, line);
    canvas.drawCircle(field.center, 3.2, dot);

    // Penalty area, goal area, spot and arc at both ends.
    final boxW = field.width * .56;
    final boxH = field.height * .14;
    final goalW = field.width * .26;
    final goalH = field.height * .055;
    for (final top in [true, false]) {
      final y0 = top ? field.top : field.bottom;
      final dir = top ? 1.0 : -1.0;
      canvas.drawRect(
          Rect.fromLTRB(cx - boxW / 2, y0, cx + boxW / 2, y0 + dir * boxH),
          line);
      canvas.drawRect(
          Rect.fromLTRB(cx - goalW / 2, y0, cx + goalW / 2, y0 + dir * goalH),
          line);
      final spot = Offset(cx, y0 + dir * boxH * .72);
      canvas.drawCircle(spot, 2.6, dot);
      canvas.drawArc(Rect.fromCircle(center: spot, radius: w * .12),
          top ? .62 : 3.1416 + .62, 3.1416 - 1.24, false, line);
    }
    // Corner arcs.
    for (final c in [
      field.topLeft,
      field.topRight,
      field.bottomLeft,
      field.bottomRight
    ]) {
      canvas.drawCircle(c, 10, line);
    }
  }

  @override
  bool shouldRepaint(_PitchBackgroundPainter old) => old.dark != dark;
}

/// Platform page transition with the app background painted under each page.
class BackgroundPageTransitionsBuilder extends PageTransitionsBuilder {
  const BackgroundPageTransitionsBuilder();

  static const _android = ZoomPageTransitionsBuilder();
  static const _ios = CupertinoPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final inner =
        Theme.of(context).platform == TargetPlatform.iOS ? _ios : _android;
    return inner.buildTransitions(route, context, animation, secondaryAnimation,
        AppBackground(child: child));
  }
}
