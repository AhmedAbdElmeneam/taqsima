import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/formatters.dart';
import '../utils/labels.dart';

/// A time slot tile with 4 states: available / app booking / manual / blocked.
///
/// Players see every non-available slot as plain "محجوز" ([ownerView] = false);
/// owners see the real state with its color and an optional subtitle.
class SlotChip extends StatelessWidget {
  const SlotChip({
    super.key,
    required this.slot,
    this.selected = false,
    this.onTap,
    this.ownerView = false,
    this.subtitle,
  });

  final TimeSlot slot;
  final bool selected;
  final VoidCallback? onTap;
  final bool ownerView;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final state = ownerView || slot.state == SlotState.available
        ? slot.state
        : SlotState.blocked; // Players: any taken slot looks the same.
    final disabled = slot.isPast || (!ownerView && !slot.isBookable);

    Color fg = state.color;
    Color bg = state.background;
    Color border = Colors.transparent;
    if (selected) {
      fg = Colors.white;
      bg = AppColors.primary;
      border = AppColors.primaryDark;
    } else if (state == SlotState.available) {
      bg = AppColors.surface;
      border = AppColors.primary.withOpacity(.35);
    }

    final label = ownerView
        ? (subtitle ?? state.label)
        : (state == SlotState.available ? null : S.legendBooked);

    return AnimatedScale(
      // Small "pop" when a slot gets selected.
      scale: selected ? 1.05 : 1,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      child: Opacity(
        opacity: slot.isPast ? .45 : 1,
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            side: BorderSide(color: border, width: 1.5),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            onTap: disabled ? null : onTap,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(minHeight: AppSpacing.slotHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Fmt.time(slot.startAt),
                      style: t.titleMedium?.copyWith(
                        color: selected
                            ? Colors.white
                            : state == SlotState.available
                                ? AppColors.ink
                                : fg,
                        decoration: !ownerView && state != SlotState.available
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (label != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (ownerView) ...[
                            Icon(state.icon, size: 16, color: fg),
                            const SizedBox(width: 3),
                          ],
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.bodySmall?.copyWith(
                                  color: fg, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Color legend for slot states.
class SlotLegend extends StatelessWidget {
  const SlotLegend({super.key, required this.states, this.playerView = false});
  final List<SlotState> states;

  /// Players see every taken slot as "محجوز".
  final bool playerView;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        for (final s in states)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: s == SlotState.available
                      ? AppColors.surface
                      : s.background,
                  border: Border.all(color: s.color, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                  playerView && s != SlotState.available
                      ? S.legendBooked
                      : s.label,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
      ],
    );
  }
}
