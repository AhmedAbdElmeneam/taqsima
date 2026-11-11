import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Size shared by both buttons. [compact] is for buttons inside cards.
const _compactHeight = 38.0;

TextStyle? _compactText(BuildContext context) => Theme.of(context)
    .textTheme
    .bodyMedium
    ?.copyWith(fontWeight: FontWeight.w700);

/// Full-width primary action (50px; 38px when [compact]).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.color,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final Color? color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final spinner = compact ? 16.0 : 22.0;
    final child = loading
        ? SizedBox(
            width: spinner,
            height: spinner,
            child: const CircularProgressIndicator(
                strokeWidth: 2.2, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: compact ? 16 : 20),
                SizedBox(width: compact ? 6 : 8)
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );
    return FilledButton(
      // Keep the filled color while loading so the white spinner is visible;
      // taps are ignored.
      onPressed: loading && onPressed != null ? () {} : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        minimumSize: compact ? const Size.fromHeight(_compactHeight) : null,
        padding: compact ? const EdgeInsets.symmetric(horizontal: 12) : null,
        textStyle: compact ? _compactText(context) : null,
        shape: compact
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))
            : null,
      ),
      child: child,
    );
  }
}

/// Full-width outlined secondary action (50px; 38px when [compact]).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool compact;

  /// Foreground color, e.g. [AppColors.error] for destructive actions.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.ink;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: fg,
        backgroundColor: AppColors.card,
        side: BorderSide(
            color: color == null ? AppColors.border : fg.withOpacity(.45),
            width: compact ? 1.2 : 1.5),
        minimumSize: compact ? const Size.fromHeight(_compactHeight) : null,
        padding: compact ? const EdgeInsets.symmetric(horizontal: 12) : null,
        textStyle: compact ? _compactText(context) : null,
        shape: compact
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 16 : 20),
            SizedBox(width: compact ? 6 : 8)
          ],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
