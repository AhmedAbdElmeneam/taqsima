import 'package:flutter/material.dart';

/// App-wide scrolling feel: soft elastic bounce on every list, no Android
/// glow/stretch and no scrollbars, so lists look calm and native.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
          parent: AlwaysScrollableScrollPhysics());

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}

/// Fades content softly as it scrolls under the top edge of the screen
/// (instead of being cut off hard at the status bar).
class TopFade extends StatelessWidget {
  const TopFade({super.key, required this.child, this.height = 28});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Colors.transparent, Colors.black],
        stops: [0, (height / rect.height).clamp(0.0, 1.0)],
      ).createShader(rect),
      child: child,
    );
  }
}
