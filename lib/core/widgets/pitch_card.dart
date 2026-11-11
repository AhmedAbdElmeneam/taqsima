import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';

import '../../data/models/models.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../utils/labels.dart';
import 'animations.dart';
import 'pitch_image.dart';

class PitchCard extends StatelessWidget {
  const PitchCard({super.key, required this.pitch, this.onTap, this.trailing});

  final Pitch pitch;
  final VoidCallback? onTap;

  /// Optional widget over the image (e.g. a status badge for owners).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return PressableScale(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  PitchImage(
                    photoKey:
                        pitch.photos.isEmpty ? pitch.id : pitch.photos.first,
                    height: 120,
                  ),
                  PositionedDirectional(
                    top: 10,
                    start: 10,
                    child: _Pill(label: pitch.type.label),
                  ),
                  if (trailing != null)
                    PositionedDirectional(top: 10, end: 10, child: trailing!),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pitch.name,
                              style: t.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(AppIcons.location,
                                  size: 18, color: AppColors.inkMuted),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(pitch.area,
                                    style: t.bodyMedium
                                        ?.copyWith(color: AppColors.inkMuted),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(S.price(pitch.pricePerHour),
                            style: t.titleMedium
                                ?.copyWith(color: AppColors.primary)),
                        Text('/ ${S.hour}', style: t.bodySmall),
                      ],
                    ),
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onPhotoInk, fontWeight: FontWeight.w800)),
      );
}
