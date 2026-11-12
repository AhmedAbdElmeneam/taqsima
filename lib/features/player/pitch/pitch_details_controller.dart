part of 'pitch_details_imports.dart';

/// Actions for the pitch details page.
class PitchDetailsController {
  PitchDetailsController(this.pitchId);
  final String pitchId;

  void openSlots(BuildContext context) =>
      context.push(Routes.pitchSlots(pitchId));
}
