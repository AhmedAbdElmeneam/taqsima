part of 'owner_profile_imports.dart';

/// Pitch management shortcuts on the owner profile.
class OwnerProfileController {
  void addPitch(BuildContext context) => context.push(Routes.ownerPitchForm);

  void editPitch(BuildContext context, Pitch p) =>
      context.push(Routes.ownerEditPitch(p.id));

  void editHours(BuildContext context, Pitch p) =>
      context.push(Routes.ownerHours(p.id));
}
