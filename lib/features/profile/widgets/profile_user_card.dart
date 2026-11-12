part of 'profile_widgets_imports.dart';

/// Avatar initial, name, phone, role and an edit button.
class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard(
      {super.key, required this.user, required this.onEditName});

  final AppUser user;
  final VoidCallback onEditName;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppPanel(
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryLight,
            child: Text(user.name.isEmpty ? '' : user.name.characters.first,
                style: t.headlineMedium?.copyWith(color: AppColors.primary)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: t.titleLarge),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(Fmt.phone(user.phone),
                      style: t.bodyLarge?.copyWith(color: AppColors.inkMuted)),
                ),
                Text(user.role == UserRole.owner ? S.owner : S.player,
                    style: t.bodySmall?.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          IconButton(
            tooltip: S.editName,
            onPressed: onEditName,
            icon: const Icon(AppIcons.edit),
          ),
        ],
      ),
    );
  }
}
