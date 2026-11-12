part of 'role_choice_widgets_imports.dart';

/// Bottom sheet-like panel with the two role cards.
class RoleChoicePanel extends StatelessWidget {
  const RoleChoicePanel(
      {super.key, required this.visible, required this.onChoose});

  final bool visible;
  final ValueChanged<UserRole> onChoose;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AnimatedSlide(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      offset: visible ? Offset.zero : const Offset(0, 1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: visible ? 1 : 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusXl)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(S.welcome, style: t.titleLarge, textAlign: TextAlign.center),
              Text(S.chooseRole,
                  style: t.bodyLarge?.copyWith(color: AppColors.inkMuted),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              RoleCard(
                icon: AppIcons.player,
                title: S.iAmPlayer,
                subtitle: S.iAmPlayerHint,
                onTap: () => onChoose(UserRole.player),
              ),
              const SizedBox(height: 12),
              RoleCard(
                icon: AppIcons.owner,
                title: S.iAmOwner,
                subtitle: S.iAmOwnerHint,
                onTap: () => onChoose(UserRole.owner),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
