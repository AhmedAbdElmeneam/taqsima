part of 'pitch_form_widgets_imports.dart';

/// Step 2: add photos from the phone, remove them, pick the cover, and tap
/// one to view it full screen.
class PhotosStep extends StatelessWidget {
  const PhotosStep({
    super.key,
    required this.photos,
    required this.onAdd,
    required this.onRemove,
    required this.onMakeCover,
    required this.onView,
  });

  final List<String> photos;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onMakeCover;
  final ValueChanged<String> onView;

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
            for (final (i, photo) in photos.indexed)
              PhotoTile(
                photo: photo,
                isCover: i == 0,
                onTap: () => onView(photo),
                onRemove: () => onRemove(photo),
                onMakeCover: () => onMakeCover(photo),
              ),
            AddPhotoTile(onTap: onAdd),
          ],
        ),
      ],
    );
  }
}

class PhotoTile extends StatelessWidget {
  const PhotoTile({
    super.key,
    required this.photo,
    required this.isCover,
    required this.onTap,
    required this.onRemove,
    required this.onMakeCover,
  });

  final String photo;
  final bool isCover;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onMakeCover;

  @override
  Widget build(BuildContext context) {
    final small = IconButton.styleFrom(
      backgroundColor: Colors.black54,
      foregroundColor: Colors.white,
      minimumSize: const Size(34, 34),
      padding: EdgeInsets.zero,
    );
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onTap,
            child: PitchImage(
              photoKey: photo,
              cacheWidth: 500,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
          ),
        ),
        PositionedDirectional(
          top: 6,
          end: 6,
          child: IconButton.filled(
            style: small,
            icon: const Icon(AppIcons.close, size: 16),
            onPressed: onRemove,
          ),
        ),
        PositionedDirectional(
          bottom: 6,
          start: 6,
          child: isCover
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(AppIcons.starFill,
                          size: 13, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(S.coverPhoto,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                    ],
                  ),
                )
              : IconButton.filled(
                  style: small,
                  tooltip: S.makeCover,
                  icon: const Icon(AppIcons.star, size: 16),
                  onPressed: onMakeCover,
                ),
        ),
      ],
    );
  }
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
