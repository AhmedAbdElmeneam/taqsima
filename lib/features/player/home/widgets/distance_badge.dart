part of 'player_home_widgets_imports.dart';

/// "1.2 كم" badge over a pitch photo.
class DistanceBadge extends StatelessWidget {
  const DistanceBadge({super.key, required this.km});
  final double km;

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: S.km(Fmt.ltr(km.toStringAsFixed(1))),
      color: AppColors.onPhotoInk,
      background: Colors.white,
      icon: AppIcons.distance,
    );
  }
}
