import 'package:flutter/material.dart';

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

    // 1. Base: grass-tinted wash, fading to neutral further down.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? const [Color(0xFF0F2318), Color(0xFF0D1712), Color(0xFF0B110E)]
              : const [Color(0xFFDDF1E3), Color(0xFFEFF6F1), Color(0xFFF6F8F7)],
          stops: const [0, .42, 1],
        ).createShader(rect),
    );

    // 2. Mowed-grass stripes across the top half, fading out.
    final stripeH = h * .055;
    for (var i = 0; i * stripeH < h * .5; i += 2) {
      final fade = 1 - (i * stripeH) / (h * .5);
      canvas.drawRect(
        Rect.fromLTWH(0, i * stripeH, w, stripeH),
        Paint()
          ..color = (dark ? const Color(0xFF2E7D4F) : const Color(0xFF1B8A3A))
              .withOpacity((dark ? .07 : .045) * fade),
      );
    }

    // 3. Light: floodlights in dark mode, soft sun glow in light mode.
    void glow(Offset c, double r, Color color) => canvas.drawCircle(
          c,
          r,
          Paint()
            ..shader = RadialGradient(colors: [color, color.withOpacity(0)])
                .createShader(Rect.fromCircle(center: c, radius: r)),
        );
    if (dark) {
      glow(Offset(-w * .05, -h * .02), w * .85,
          const Color(0xFFBFF5D2).withOpacity(.10));
      glow(Offset(w * 1.05, -h * .02), w * .85,
          const Color(0xFFBFF5D2).withOpacity(.10));
    } else {
      glow(Offset(w * .9, h * .02), w * .75, Colors.white.withOpacity(.55));
      glow(Offset(0, h * .6), w * .6, const Color(0xFF7CC9A0).withOpacity(.12));
    }

    // 4. Field markings at the top of the screen.
    final line = Paint()
      ..color = (dark ? Colors.white : const Color(0xFF1B8A3A))
          .withOpacity(dark ? .06 : .08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final top = h * .015;
    final fieldH = h * .36;
    final midY = top + fieldH / 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .04, top, w * .92, fieldH),
          const Radius.circular(4)),
      line,
    );
    canvas.drawLine(Offset(w * .04, midY), Offset(w * .96, midY), line);
    canvas.drawCircle(Offset(w / 2, midY), w * .16, line);
    // Penalty box + goal area at the top edge.
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(w / 2, top + fieldH * .1),
            width: w * .5,
            height: fieldH * .2),
        line);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(w / 2, top + fieldH * .04),
            width: w * .24,
            height: fieldH * .08),
        line);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(w / 2, top + fieldH * .2), radius: w * .1),
        0,
        3.1416,
        false,
        line);
    final dot = Paint()..color = line.color;
    canvas.drawCircle(Offset(w / 2, midY), 3, dot);
    canvas.drawCircle(Offset(w / 2, top + fieldH * .14), 2.4, dot);
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
