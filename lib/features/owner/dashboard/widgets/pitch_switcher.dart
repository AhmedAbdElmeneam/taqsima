import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../owner_providers.dart';

/// Tappable pitch name that lets owners with several pitches switch.
class PitchSwitcher extends ConsumerWidget {
  const PitchSwitcher({super.key, required this.pitch, this.onDark = false});
  final Pitch pitch;

  /// White text and icons, for use on the green header card.
  final bool onDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitches = ref.watch(ownerPitchesProvider).valueOrNull ?? const [];
    final t = Theme.of(context).textTheme;
    final canSwitch = pitches.length > 1;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      onTap: !canSwitch
          ? null
          : () => showAppBottomSheet<void>(
                context,
                title: S.choosePitch,
                builder: (ctx) => Column(
                  children: [
                    for (final p in pitches)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: PitchThumb(
                            photoKey: p.coverPhoto,
                            size: 48,
                            radius: AppSpacing.radiusSm),
                        title: Text(p.name, style: t.titleMedium),
                        subtitle: Text(p.area),
                        trailing: p.id == pitch.id
                            ? Icon(AppIcons.confirmed, color: AppColors.primary)
                            : PitchStatusBadge(status: p.status),
                        onTap: () {
                          ref.read(selectedPitchIdProvider.notifier).state =
                              p.id;
                          Navigator.pop(ctx);
                        },
                      ),
                  ],
                ),
              ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!onDark) ...[
              Icon(AppIcons.pitch, color: AppColors.primary),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(pitch.name,
                  style: onDark
                      ? t.headlineMedium
                          ?.copyWith(color: Colors.white, fontSize: 22)
                      : t.titleLarge,
                  overflow: TextOverflow.ellipsis),
            ),
            if (canSwitch)
              Icon(AppIcons.dropdown,
                  size: onDark ? 22 : 28,
                  color: onDark ? Colors.white70 : null),
          ],
        ),
      ),
    );
  }
}
