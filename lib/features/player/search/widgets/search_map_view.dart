part of 'search_widgets_imports.dart';

/// Map placeholder with one pin per pitch.
class SearchMapView extends StatelessWidget {
  const SearchMapView({super.key, required this.pitches, required this.onOpen});

  final List<Pitch> pitches;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(20, 0, 20, AppSpacing.navBarClearance),
      child: Column(
        children: [
          Expanded(
            child: MapPlaceholder(
              pins: [
                for (final p in pitches)
                  MapPin(id: p.id, lat: p.lat, lng: p.lng, label: p.name),
              ],
              onPinTap: (pin) => onOpen(pin.id),
            ),
          ),
          const SizedBox(height: 8),
          Text(S.mapPlaceholderNote,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
