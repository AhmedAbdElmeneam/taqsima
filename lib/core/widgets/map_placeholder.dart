import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MapPin {
  const MapPin({required this.id, required this.lat, required this.lng, this.label});
  final String id;
  final double lat;
  final double lng;
  final String? label;
}

/// Static, code-drawn map of Greater Cairo used until a real map SDK is added.
/// Supports tappable pins and (optionally) picking a point.
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({
    super.key,
    this.pins = const [],
    this.onPinTap,
    this.onPick,
    this.picked,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final List<MapPin> pins;
  final ValueChanged<MapPin>? onPinTap;

  /// Called with (lat, lng) when the user taps the map.
  final void Function(double lat, double lng)? onPick;
  final ({double lat, double lng})? picked;
  final double? height;
  final BorderRadius borderRadius;

  // Approximate bounds of Greater Cairo.
  static const _minLat = 29.93, _maxLat = 30.13;
  static const _minLng = 30.92, _maxLng = 31.52;

  static Offset _toOffset(double lat, double lng, Size s) => Offset(
        ((lng - _minLng) / (_maxLng - _minLng)).clamp(.04, .96) * s.width,
        (1 - (lat - _minLat) / (_maxLat - _minLat)).clamp(.06, .94) * s.height,
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        child: LayoutBuilder(builder: (context, c) {
          final size = Size(c.maxWidth, c.maxHeight);
          return GestureDetector(
            onTapUp: onPick == null
                ? null
                : (d) {
                    final p = d.localPosition;
                    final lng = _minLng + p.dx / size.width * (_maxLng - _minLng);
                    final lat =
                        _minLat + (1 - p.dy / size.height) * (_maxLat - _minLat);
                    onPick!(lat, lng);
                  },
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _MapPainter())),
                for (final pin in pins)
                  _positioned(size, pin.lat, pin.lng,
                      _Pin(label: pin.label, onTap: () => onPinTap?.call(pin))),
                if (picked != null)
                  _positioned(size, picked!.lat, picked!.lng, const _Pin()),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _positioned(Size size, double lat, double lng, Widget child) {
    final o = _toOffset(lat, lng, size);
    return Positioned(
      left: o.dx - 60,
      top: o.dy - 44,
      width: 120,
      child: child,
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({this.label, this.onTap});
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(label!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          const Icon(Icons.location_on, size: 34, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFEFF1EC));

    // Blocks.
    final block = Paint()..color = const Color(0xFFE3E6DF);
    const step = 38.0;
    for (var x = 6.0; x < size.width; x += step) {
      for (var y = 6.0; y < size.height; y += step) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(x, y, step - 10, step - 10), const Radius.circular(4)),
            block);
      }
    }

    // Parks.
    final park = Paint()..color = const Color(0xFFD5EBD3);
    canvas.drawCircle(Offset(size.width * .72, size.height * .3), 28, park);
    canvas.drawCircle(Offset(size.width * .2, size.height * .65), 22, park);

    // The Nile.
    final nile = Path()
      ..moveTo(size.width * .40, 0)
      ..cubicTo(size.width * .46, size.height * .3, size.width * .38,
          size.height * .6, size.width * .45, size.height);
    canvas.drawPath(
        nile,
        Paint()
          ..color = const Color(0xFFAFD3EE)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16);

    // Main roads.
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * .45),
        Offset(size.width, size.height * .38), road);
    canvas.drawLine(Offset(size.width * .65, 0),
        Offset(size.width * .7, size.height), road);
    canvas.drawLine(Offset(0, size.height * .8),
        Offset(size.width, size.height * .7), road);
    canvas.drawLine(Offset(size.width * .15, 0),
        Offset(size.width * .25, size.height), road);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
