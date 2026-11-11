import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Full-width, 56px-tall primary action.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
                strokeWidth: 2.5, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 22),
                const SizedBox(width: 8)
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );
    return FilledButton(
      // Keep the filled color while loading so the white spinner is visible;
      // taps are ignored.
      onPressed: loading && onPressed != null ? () {} : onPressed,
      style:
          color == null ? null : FilledButton.styleFrom(backgroundColor: color),
      child: child,
    );
  }
}

/// Full-width outlined secondary action.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Foreground color, e.g. [AppColors.error] for destructive actions.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.ink;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: fg,
        side: BorderSide(
            color: color == null ? AppColors.border : fg.withOpacity(.5),
            width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 8)],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
