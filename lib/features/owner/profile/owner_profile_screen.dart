import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../profile/profile_screen.dart';
import '../owner_providers.dart';

/// Owner profile: shared profile/settings + "my pitches" with their status.
class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const ProfileScreen(extra: [SizedBox(height: 20), _MyPitches()]);
}

class _MyPitches extends ConsumerWidget {
  const _MyPitches();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitches = ref.watch(ownerPitchesProvider);
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: S.myPitches,
          action: S.addPitch,
          onAction: () => context.push(Routes.ownerPitchForm),
        ),
        const SizedBox(height: 6),
        AsyncView(
          value: pitches,
          builder: (list) => Column(
            children: [
              for (final p in list) ...[
                AppPanel(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 54,
                            height: 54,
                            child: PitchImage(
                              photoKey:
                                  p.photos.isEmpty ? p.id : p.photos.first,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: t.titleMedium),
                                Text(p.area,
                                    style: t.bodyMedium
                                        ?.copyWith(color: AppColors.inkMuted)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('${S.pitchStatus}: ',
                                        style: t.bodySmall),
                                    PitchStatusBadge(status: p.status),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (p.status == PitchStatus.pending)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(S.underReviewHint, style: t.bodySmall),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48)),
                              onPressed: () =>
                                  context.push(Routes.ownerEditPitch(p.id)),
                              icon: const Icon(AppIcons.edit),
                              label: const Text(S.edit),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48)),
                              onPressed: () =>
                                  context.push(Routes.ownerHours(p.id)),
                              icon: const Icon(AppIcons.clock),
                              label: const Text(S.hours),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
