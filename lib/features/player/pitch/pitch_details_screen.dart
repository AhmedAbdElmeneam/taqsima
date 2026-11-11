import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';

class PitchDetailsScreen extends ConsumerWidget {
  const PitchDetailsScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitch = ref.watch(pitchProvider(pitchId));
    return Scaffold(
      body: AsyncView(
        value: pitch,
        builder: (p) => p == null
            ? const EmptyState(icon: AppIcons.pitch, title: S.noResults)
            : _Body(pitch: p),
      ),
      bottomNavigationBar: pitch.valueOrNull == null
          ? null
          : BottomActionBar(
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.startingFrom,
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        S.pricePerHour(pitch.value!.pricePerHour),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      label: S.book,
                      icon: AppIcons.calendarCheck,
                      onPressed: () => context.push(Routes.pitchSlots(pitchId)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.pitch});
  final Pitch pitch;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          title: Text(pitch.name,
              style: t.titleLarge?.copyWith(color: Colors.white)),
          flexibleSpace: FlexibleSpaceBar(
            background: _Carousel(photos: pitch.photos),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList.list(
            children: [
              Row(
                children: [
                  Expanded(child: Text(pitch.name, style: t.headlineMedium)),
                  AppBadge(
                    label: pitch.type.label,
                    color: AppColors.primaryDark,
                    background: AppColors.primaryLight,
                    icon: AppIcons.team,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(AppIcons.location,
                      color: AppColors.inkMuted, size: 20),
                  const SizedBox(width: 4),
                  Text(pitch.area,
                      style: t.bodyLarge?.copyWith(color: AppColors.inkMuted)),
                ],
              ),
              const SizedBox(height: 20),
              Text(S.amenities, style: t.titleLarge),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final a in pitch.amenities)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(a.icon, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(a.label,
                              style: t.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(S.about, style: t.titleLarge),
              const SizedBox(height: 6),
              Text(pitch.description,
                  style: t.bodyLarge?.copyWith(height: 1.7)),
              const SizedBox(height: 20),
              Text(S.location, style: t.titleLarge),
              const SizedBox(height: 10),
              MapPlaceholder(
                height: 170,
                pins: [
                  MapPin(
                      id: pitch.id,
                      lat: pitch.lat,
                      lng: pitch.lng,
                      label: pitch.name)
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _Carousel extends StatefulWidget {
  const _Carousel({required this.photos});
  final List<String> photos;

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos.isEmpty ? const ['empty'] : widget.photos;
    return Stack(
      children: [
        PageView.builder(
          itemCount: photos.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) => PitchImage(photoKey: photos[i]),
        ),
        Positioned(
          bottom: 14,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < photos.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
