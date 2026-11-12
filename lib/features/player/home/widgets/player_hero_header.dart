part of 'player_home_widgets_imports.dart';

/// Player home header: greeting, question, and the player's next match
/// (live / countdown) — or a nudge to book when nothing is coming up.
class PlayerHeroHeader extends StatelessWidget {
  const PlayerHeroHeader({
    super.key,
    required this.firstName,
    required this.next,
    required this.onFindMatch,
    required this.onOpenBooking,
  });

  final String firstName;
  final Booking? next;
  final VoidCallback onFindMatch;
  final ValueChanged<Booking> onOpenBooking;

  @override
  Widget build(BuildContext context) {
    final booking = next;
    return HeroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroGreeting(name: firstName),
          const SizedBox(height: 4),
          Text(S.homeQuestion,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          booking == null
              ? HeroStrip(
                  onTap: onFindMatch,
                  child: HeroStripMessage(
                    icon: AppIcons.ball,
                    text: S.noUpcomingMatch,
                    action: Icon(AppIcons.forward,
                        size: 16, color: Colors.white.withOpacity(.9)),
                  ),
                )
              : NextMatchStrip(
                  booking: booking,
                  onTap: () => onOpenBooking(booking),
                ),
        ],
      ),
    );
  }
}
