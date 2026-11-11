import '../../data/models/models.dart';

/// All route paths in one place.
abstract final class Routes {
  // Shared
  static const splash = '/';
  static const loginPath = '/login';
  static String login(UserRole role) => '$loginPath?role=${role.name}';
  static const otp = '/otp';

  // Player (tabs)
  static const playerHome = '/player/home';
  static const playerSearch = '/player/search';
  static const playerBookings = '/player/bookings';
  static const playerProfile = '/player/profile';

  // Player (full screen)
  static String pitch(String id) => '/player/pitch/$id';
  static String pitchSlots(String id) => '/player/pitch/$id/slots';
  static const confirmBooking = '/player/confirm';
  static String bookingSuccess(String id) => '/player/success/$id';
  static String playerBooking(String id) => '/player/bookings/$id';

  // Owner (tabs)
  static const ownerToday = '/owner/today';
  static const ownerCalendar = '/owner/calendar';
  static const ownerRequests = '/owner/requests';
  static const ownerProfile = '/owner/profile';

  // Owner (full screen)
  static const ownerPitchForm = '/owner/pitch-form';
  static String ownerEditPitch(String id) => '$ownerPitchForm?id=$id';
  static String ownerHours(String pitchId) => '/owner/hours/$pitchId';
  static String ownerBooking(String id) => '/owner/booking/$id';
}

class OtpArgs {
  const OtpArgs({required this.phone, required this.role, this.name});
  final String phone;
  final UserRole role;
  final String? name;
}
