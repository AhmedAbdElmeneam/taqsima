enum UserRole { player, owner, admin }

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
  });

  final String id;
  final String name;
  final String phone;
  final UserRole role;

  AppUser copyWith({String? name, String? phone, UserRole? role}) => AppUser(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        role: role ?? this.role,
      );
}
