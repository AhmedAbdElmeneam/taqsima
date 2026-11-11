import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import 'empty_state.dart';

/// Renders an [AsyncValue] keeping old data visible while reloading.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.builder});

  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: builder,
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => const EmptyState(
        icon: AppIcons.offline,
        title: S.somethingWrong,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(
      {super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

/// Icon + label + value row used in summaries.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Text(label, style: t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: t.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// White rounded container for grouping content.
class AppPanel extends StatelessWidget {
  const AppPanel({super.key, required this.child, this.padding, this.color});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: color == null ? softShadow : null,
        ),
        child: child,
      );
}

/// The one shadow used for floating surfaces.
const softShadow = [
  BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 6)),
];

/// Floating bottom action area (e.g. "احجز"), same style as the nav bar.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: GlassContainer(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      );
}

/// Frosted, bordered, rounded surface that floats over the background.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.radius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F0F2A1C), blurRadius: 30, offset: Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.72),
              borderRadius: BorderRadius.circular(radius),
              border:
                  Border.all(color: Colors.white.withOpacity(.9), width: 1.2),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
