part of 'pitch_details_widgets_imports.dart';

/// Icon + label for one amenity.
class AmenityTile extends StatelessWidget {
  const AmenityTile({super.key, required this.amenity});
  final Amenity amenity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(amenity.icon, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(amenity.label,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
