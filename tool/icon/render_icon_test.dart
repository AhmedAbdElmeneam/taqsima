// Renders the app icon artwork to PNG files in assets/icon/.
//
// Run:  flutter test tool/icon/render_icon_test.dart
// Then: dart run flutter_launcher_icons && dart run flutter_native_splash:create
//
// Everything is drawn with paths (no fonts/images), so the output is the same
// on every machine.

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _green = Color(0xFF1B8A3A);
const _greenLight = Color(0xFF27A44C);
const _greenDark = Color(0xFF0F5C26);
const _patch = Color(0xFF14321F);

void main() {
  test('render app icon artwork', () async {
    Directory('assets/icon').createSync(recursive: true);

    // Full icon (iOS + legacy Android): pitch-green tile with the ball.
    await _save('assets/icon/icon.png', 1024, (c, s) {
      _paintBackground(c, s);
      _paintBall(c, s.center(Offset.zero), s.width * .30);
    });

    // Adaptive icon layers (Android 8+): the launcher crops the outer third,
    // so the ball stays inside the central safe zone.
    await _save('assets/icon/background.png', 1024, _paintBackground);
    await _save('assets/icon/foreground.png', 1024, (c, s) {
      // flutter_launcher_icons adds a 16% inset, so the ball is drawn larger.
      _paintBall(c, s.center(Offset.zero), s.width * .30);
    });

    // Monochrome layer (Android 13 themed icons): only the ball outline,
    // patches and seams are opaque; the white parts are transparent.
    await _save('assets/icon/monochrome.png', 1024, (c, s) {
      _paintBall(c, s.center(Offset.zero), s.width * .30, mono: true);
    });

    // Splash: ball only (shown on the green splash background).
    await _save('assets/icon/splash.png', 768, (c, s) {
      _paintBall(c, s.center(Offset.zero), s.width * .30);
    });
  });
}

Future<void> _save(
    String path, int size, void Function(Canvas, Size) paint) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final s = Size(size.toDouble(), size.toDouble());
  paint(canvas, s);
  final image = await recorder.endRecording().toImage(size, size);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
}

/// Gradient pitch green with soft mowing stripes and a faint centre circle.
void _paintBackground(Canvas canvas, Size s) {
  final rect = Offset.zero & s;
  canvas.drawRect(
    rect,
    Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_greenLight, _green, _greenDark],
        stops: [0, .5, 1],
      ).createShader(rect),
  );
  final stripe = Paint()..color = Colors.white.withOpacity(.05);
  final w = s.width / 8;
  for (var i = 0; i < 8; i += 2) {
    canvas.drawRect(Rect.fromLTWH(i * w, 0, w, s.height), stripe);
  }
  final line = Paint()
    ..color = Colors.white.withOpacity(.16)
    ..style = PaintingStyle.stroke
    ..strokeWidth = s.width * .012;
  canvas.drawLine(Offset(0, s.height / 2), Offset(s.width, s.height / 2), line);
  canvas.drawCircle(s.center(Offset.zero), s.width * .40, line);
}

/// A classic football: white ball, dark centre pentagon, five edge patches.
void _paintBall(Canvas canvas, Offset c, double r, {bool mono = false}) {
  final ink = mono ? Colors.white : _patch;
  if (!mono) {
    // Soft shadow.
    canvas.drawCircle(
      c + Offset(0, r * .08),
      r * 1.02,
      Paint()
        ..color = Colors.black.withOpacity(.22)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * .08),
    );
    canvas.drawCircle(c, r, Paint()..color = Colors.white);
  }

  canvas.save();
  canvas.clipPath(Path()..addOval(Rect.fromCircle(center: c, radius: r)));

  final patch = Paint()..color = ink;
  final seam = Paint()
    ..color = ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = r * .045
    ..strokeCap = StrokeCap.round;

  Path pentagon(Offset center, double radius, double rotation) {
    final p = Path();
    for (var i = 0; i < 5; i++) {
      final a = rotation + i * 2 * math.pi / 5;
      final pt = center + Offset(math.cos(a), math.sin(a)) * radius;
      i == 0 ? p.moveTo(pt.dx, pt.dy) : p.lineTo(pt.dx, pt.dy);
    }
    return p..close();
  }

  const up = -math.pi / 2;
  final inner = r * .34;
  canvas.drawPath(pentagon(c, inner, up), patch);

  for (var i = 0; i < 5; i++) {
    final a = up + i * 2 * math.pi / 5;
    final dir = Offset(math.cos(a), math.sin(a));
    // Seam from the centre patch's corner out to the edge patch.
    canvas.drawLine(c + dir * inner, c + dir * r, seam);
    // Edge patch, mostly outside the circle (clipped).
    final outerCenter = c +
        Offset(math.cos(a + math.pi / 5), math.sin(a + math.pi / 5)) * r * 1.02;
    canvas.drawPath(pentagon(outerCenter, r * .34, a + math.pi / 5), patch);
  }
  canvas.restore();

  // Thin rim so the ball reads on light launchers.
  canvas.drawCircle(
    c,
    r,
    Paint()
      ..color = mono ? ink : _patch.withOpacity(.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = mono ? r * .06 : r * .02,
  );
}
