enum PitchType { fiveASide, sevenASide }

enum Amenity { artificialGrass, lighting, toilets, parking }

enum PitchStatus { pending, active }

class Pitch {
  const Pitch({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.area,
    required this.lat,
    required this.lng,
    required this.type,
    required this.pricePerHour,
    required this.photos,
    required this.amenities,
    required this.status,
  });

  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String area;
  final double lat;
  final double lng;
  final PitchType type;

  /// Price in EGP for one hour.
  final int pricePerHour;

  /// Photo URLs. In the mock phase these are keys rendered by [PitchImage].
  final List<String> photos;
  final List<Amenity> amenities;
  final PitchStatus status;

  /// Photo shown on cards and thumbnails. Falls back to the pitch id so the
  /// placeholder image stays stable when there are no photos yet.
  String get coverPhoto => photos.isEmpty ? id : photos.first;

  Pitch copyWith({
    String? name,
    String? description,
    String? area,
    double? lat,
    double? lng,
    PitchType? type,
    int? pricePerHour,
    List<String>? photos,
    List<Amenity>? amenities,
    PitchStatus? status,
  }) =>
      Pitch(
        id: id,
        ownerId: ownerId,
        name: name ?? this.name,
        description: description ?? this.description,
        area: area ?? this.area,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        type: type ?? this.type,
        pricePerHour: pricePerHour ?? this.pricePerHour,
        photos: photos ?? this.photos,
        amenities: amenities ?? this.amenities,
        status: status ?? this.status,
      );
}
