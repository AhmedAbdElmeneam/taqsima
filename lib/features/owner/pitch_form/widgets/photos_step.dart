part of 'pitch_form_widgets_imports.dart';

/// Step 2: add / remove photos (mock: adding creates a placeholder image).
class PhotosStep extends StatelessWidget {
  const PhotosStep({
    super.key,
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> photos;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(S.photosHint,
            style: t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            for (final photo in photos)
              PhotoTile(photo: photo, onRemove: () => onRemove(photo)),
            AddPhotoTile(onTap: onAdd),
          ],
        ),
      ],
    );
  }
}

class PhotoTile extends StatelessWidget {
  const PhotoTile({super.key, required this.photo, required this.onRemove});
  final String photo;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: PitchImage(
                photoKey: photo,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
          ),
          PositionedDirectional(
            top: 6,
            end: 6,
            child: IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
              icon: const Icon(AppIcons.close, size: 18),
              onPressed: onRemove,
            ),
          ),
        ],
      );
}

class AddPhotoTile extends StatelessWidget {
  const AddPhotoTile({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(AppIcons.addPhoto, size: 28, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(S.addPhoto,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      );
}
