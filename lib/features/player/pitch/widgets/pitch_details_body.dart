part of 'pitch_details_widgets_imports.dart';

/// Photo app bar + info, amenities, description and location.
class PitchDetailsBody extends StatelessWidget {
  const PitchDetailsBody({super.key, required this.pitch});
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
            background: PitchPhotoCarousel(photos: pitch.photos),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList.list(
            children: [
              PitchInfoHeader(pitch: pitch),
              const SizedBox(height: 20),
              Text(S.amenities, style: t.titleLarge),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final a in pitch.amenities) AmenityTile(amenity: a),
                ],
              ),
              const SizedBox(height: 20),
              if (pitch.photos.isNotEmpty) ...[
                Text(S.pitchPhotos, style: t.titleLarge),
                const SizedBox(height: 10),
                PhotoStrip(photos: pitch.photos),
                const SizedBox(height: 20),
              ],
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
                      label: pitch.name),
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
