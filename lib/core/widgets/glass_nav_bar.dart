import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'common.dart';

class GlassNavItem {
  const GlassNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badge = 0,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int badge;
}

/// Floating frosted-glass bottom navigation bar.
/// Use inside a Scaffold with `extendBody: true` so content shows behind it.
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<GlassNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 14),
      child: GlassContainer(
        margin: const EdgeInsets.symmetric(horizontal: 22),
        padding: const EdgeInsets.all(6),
        // Fully rounded (pill) glass bar with a visible outline.
        radius: 40,
        strongBorder: true,
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _NavButton(
                  item: items[i],
                  selected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final GlassNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final color = selected ? AppColors.primary : AppColors.inkMuted;
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 52,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                isLabelVisible: item.badge > 0,
                label: Text('${item.badge}'),
                backgroundColor: AppColors.error,
                // Selected icon gives a small bounce.
                child: AnimatedScale(
                  scale: selected ? 1.12 : 1,
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.elasticOut,
                  child: Icon(selected ? item.selectedIcon : item.icon,
                      size: 22, color: color),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.bodySmall?.copyWith(
                  fontSize: 10.5,
                  height: 1.2,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
