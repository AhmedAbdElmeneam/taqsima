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

/// Body for a bottom-nav tab: no app bar — the title scrolls with the content
/// and fades under the status bar, exactly like the home screen.
class TabPage extends StatelessWidget {
  const TabPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopFade(
        height: MediaQuery.paddingOf(context).top + 24,
        child: SafeArea(bottom: false, child: child),
      ),
    );
  }
}

/// Large page title used at the top of a [TabPage].
class PageTitle extends StatelessWidget {
  const PageTitle(this.text, {super.key, this.padding});
  final String text;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Text(text, style: Theme.of(context).textTheme.headlineMedium),
      );
}
