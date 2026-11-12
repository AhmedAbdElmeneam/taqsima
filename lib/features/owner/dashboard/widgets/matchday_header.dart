part of 'owner_dashboard_widgets_imports.dart';

/// Owner home header styled like a stadium scoreboard: greeting, date,
/// pitch (tap to switch) and a live strip with the next booking countdown.
class MatchdayHeader extends ConsumerWidget {
  const MatchdayHeader({super.key, required this.pitch, required this.slots});

  final Pitch pitch;

  /// Today's computed slots (null while loading).
  final List<TimeSlot>? slots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider);
    final firstName = (user?.name ?? '').split(' ').take(2).join(' ');

    return HeroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroGreeting(name: firstName),
          const SizedBox(height: 4),
          PitchSwitcher(pitch: pitch, onDark: true),
          const SizedBox(height: 12),
          NextBookingStrip(slots: slots),
        ],
      ),
    );
  }
}
