part of 'owner_booking_details_widgets_imports.dart';

/// Player / customer name, phone (or the "hidden" note) and source.
class BookingCustomerPanel extends StatelessWidget {
  const BookingCustomerPanel({
    super.key,
    required this.booking,
    required this.player,
    required this.phoneVisible,
  });

  final Booking booking;
  final AppUser? player;
  final bool phoneVisible;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final isApp = b.source == BookingSource.app;
    final p = player;
    return AppPanel(
      child: Column(
        children: [
          InfoRow(
            icon: AppIcons.profile,
            label: S.playerName,
            value: isApp ? (p?.name ?? '') : (b.customerName ?? S.noName),
          ),
          if (isApp)
            InfoRow(
              icon: AppIcons.phone,
              label: S.playerPhone,
              value: phoneVisible && p != null
                  ? Fmt.phone(p.phone)
                  : S.phoneHiddenUntilConfirm,
              valueColor: phoneVisible ? null : AppColors.inkFaint,
            ),
          InfoRow(
            icon: isApp ? AppIcons.mobile : AppIcons.manual,
            label: S.source,
            value: isApp ? S.sourceApp : S.sourceManual,
          ),
        ],
      ),
    );
  }
}
