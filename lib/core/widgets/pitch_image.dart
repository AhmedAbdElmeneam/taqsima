import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Placeholder pitch photo drawn in code (no network or assets needed).
/// [photoKey] picks a stable variation; swap for Image.network with a backend.
class PitchImage extends StatelessWidget {
  const PitchImage({
    super.key,
    required this.photoKey,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  final String photoKey;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _PitchPainter(photoKey.hashCode)),
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  _PitchPainter(this.seed);
  final int seed;

  static const _greens = [
    [Color(0xFF2E9E4F), Color(0xFF278A44)],
    [Color(0xFF1F8A3E), Color(0xFF1A7535)],
    [Color(0xFF3BAA5C), Color(0xFF33964F)],
    [Color(0xFF248F4A), Color(0xFF1E7B3F)],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final palette = _greens[seed.abs() % _greens.length];
    final stripes = 8 + rnd.nextInt(4);
    final w = size.width / stripes;
    for (var i = 0; i < stripes; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * w, 0, w + 1, size.height),
        Paint()..color = palette[i % 2],
      );
    }

    // Night lighting glow on some variations.
    if (rnd.nextBool()) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = RadialGradient(
            center: Alignment(rnd.nextDouble() * 2 - 1, -1.2),
            radius: 1.2,
            colors: [Colors.white.withOpacity(.22), Colors.transparent],
          ).createShader(Offset.zero & size),
      );
    }

    final line = Paint()
      ..color = Colors.white.withOpacity(.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final m = size.shortestSide * .1;
    final field = Rect.fromLTRB(m, m, size.width - m, size.height - m);
    canvas.drawRect(field, line);
    canvas.drawLine(Offset(field.center.dx, field.top),
        Offset(field.center.dx, field.bottom), line);
    canvas.drawCircle(field.center, field.height * .18, line);
    canvas.drawCircle(field.center, 3, line..style = PaintingStyle.fill);
    line.style = PaintingStyle.stroke;
    final boxH = field.height * .45;
    final boxW = field.width * .1;
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(field.left + boxW / 2, field.center.dy),
            width: boxW,
            height: boxH),
        line);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(field.right - boxW / 2, field.center.dy),
            width: boxW,
            height: boxH),
        line);

    // Ball.
    final ball = Offset(field.left + field.width * (.3 + rnd.nextDouble() * .4),
        field.top + field.height * (.3 + rnd.nextDouble() * .4));
    canvas.drawCircle(ball, 7, Paint()..color = Colors.white);
    canvas.drawCircle(ball, 3, Paint()..color = const Color(0xFF1A2332));

    // Bottom shade for overlaid text legibility.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(.25)],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_PitchPainter old) => old.seed != seed;
}
