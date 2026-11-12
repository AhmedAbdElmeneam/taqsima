part of 'weekly_calendar_widgets_imports.dart';

/// Dims (and disables) cells hidden by the filter, with a short fade + shrink.
class FilteredCell extends StatelessWidget {
  const FilteredCell({super.key, required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : .12,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          scale: visible ? 1 : .92,
          child: child,
        ),
      ),
    );
  }
}
