import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// App-wide background: a soft mint wash with two blurred green glows and the
/// faint lines of a football pitch. Every Scaffold is transparent on top of it.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
            child: CustomPaint(painter: _BackgroundPainter())),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base wash.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F3E8), Color(0xFFF3F7F4), Color(0xFFF7F9F8)],
          stops: [0, .45, 1],
        ).createShader(rect),
    );

    // Soft glows.
    void glow(Offset c, double r, Color color) => canvas.drawCircle(
          c,
          r,
          Paint()
            ..shader = RadialGradient(colors: [color, color.withOpacity(0)])
                .createShader(Rect.fromCircle(center: c, radius: r)),
        );
    glow(Offset(size.width * .95, size.height * .05), size.width * .7,
        AppColors.primary.withOpacity(.16));
    glow(Offset(size.width * .0, size.height * .55), size.width * .6,
        const Color(0xFF7CC9A0).withOpacity(.14));

    // Faint pitch lines at the top.
    final line = Paint()
      ..color = AppColors.primary.withOpacity(.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final cx = size.width / 2;
    final top = size.height * .02;
    final h = size.height * .32;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(-20, top, size.width + 40, h),
          const Radius.circular(6)),
      line,
    );
    canvas.drawLine(
        Offset(-20, top + h / 2), Offset(size.width + 20, top + h / 2), line);
    canvas.drawCircle(Offset(cx, top + h / 2), size.width * .17, line);
    canvas.drawCircle(
        Offset(cx, top + h / 2), 3, line..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
