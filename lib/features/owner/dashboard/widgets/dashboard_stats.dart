part of 'owner_dashboard_widgets_imports.dart';

/// Revenue (highlighted), bookings and free slots.
class DashboardStats extends StatelessWidget {
  const DashboardStats({
    super.key,
    required this.revenue,
    required this.booked,
    required this.free,
  });

  final int revenue;
  final int booked;
  final int free;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: StatCard(
            label: S.todaysRevenue,
            value: S.price(revenue),
            amount: revenue,
            icon: AppIcons.moneyFill,
            highlight: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: StatCard(
            label: S.bookingsCount,
            value: '$booked',
            icon: AppIcons.calendarCheck,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: StatCard(
            label: S.freeSlots,
            value: '$free',
            icon: AppIcons.calendarPlus,
          ),
        ),
      ],
    );
  }
}
