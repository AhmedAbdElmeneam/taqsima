import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/widgets.dart';

/// Step 3: tap the map to place the pitch.
class LocationStep extends StatelessWidget {
  const LocationStep({super.key, required this.location, required this.onPick});

  final ({double lat, double lng})? location;
  final void Function(double lat, double lng) onPick;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(location == null ? AppIcons.tap : AppIcons.confirmed,
                  color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(location == null ? S.tapMapToPin : S.locationSet,
                    style: t.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: MapPlaceholder(picked: location, onPick: onPick)),
        ],
      ),
    );
  }
}
