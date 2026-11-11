import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/repositories.dart';
import '../../auth/session_controller.dart';
import '../player_providers.dart';
import '../search/filter_sheet.dart';

class PlayerHomeScreen extends ConsumerWidget {
  const PlayerHomeScreen({super.key});

  void _searchWith(WidgetRef ref, BuildContext context, PitchFilter filter) {
    ref.read(searchFilterProvider.notifier).state = filter;
    context.go(Routes.playerSearch);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);
    final pitches = ref.watch(nearbyPitchesProvider);
    final t = Theme.of(context).textTheme;
    final firstName = (user?.name ?? '').split(' ').first;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.refresh(nearbyPitchesProvider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(S.hello(firstName),
                  style: t.bodyLarge?.copyWith(color: AppColors.inkMuted)),
              Text(S.homeQuestion, style: t.headlineMedium),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: S.searchHint,
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      onSubmitted: (q) => _searchWith(
                          ref,
                          context,
                          ref
                              .read(searchFilterProvider)
                              .copyWith(query: () => q)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _FilterButton(onTap: () async {
                    if (await showFilterSheet(context) && context.mounted) {
                      context.go(Routes.playerSearch);
                    }
                  }),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final type in PitchType.values)
                      _QuickChip(
                        icon: Icons.groups_rounded,
                        label: type.label,
                        onTap: () =>
                            _searchWith(ref, context, PitchFilter(type: type)),
                      ),
                    for (final area in const [
                      'مدينة نصر',
                      'المعادي',
                      'التجمع الخامس',
                      'الشيخ زايد'
                    ])
                      _QuickChip(
                        icon: Icons.location_on_outlined,
                        label: area,
                        onTap: () =>
                            _searchWith(ref, context, PitchFilter(area: area)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(
                title: S.nearbyPitches,
                action: S.seeAll,
                onAction: () => _searchWith(ref, context, const PitchFilter()),
              ),
              const SizedBox(height: 8),
              AsyncView(
                value: pitches,
                builder: (list) => Column(
                  children: [
                    for (final p in list) ...[
                      PitchCard(
                        pitch: p,
                        trailing: _DistanceBadge(pitch: p),
                        onTap: () => context.push(Routes.pitch(p.id)),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.tune_rounded, color: Colors.white),
          ),
        ),
      );
}

class _QuickChip extends StatelessWidget {
  const _QuickChip(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: ActionChip(
          avatar: Icon(icon, size: 18, color: AppColors.primary),
          label: Text(label),
          onPressed: onTap,
        ),
      );
}

class _DistanceBadge extends StatelessWidget {
  const _DistanceBadge({required this.pitch});
  final Pitch pitch;

  @override
  Widget build(BuildContext context) {
    final km = distanceKm(
        playerLocation.lat, playerLocation.lng, pitch.lat, pitch.lng);
    return AppBadge(
      label: S.km(km.toStringAsFixed(1)),
      color: AppColors.ink,
      background: Colors.white,
      icon: Icons.near_me_rounded,
    );
  }
}
