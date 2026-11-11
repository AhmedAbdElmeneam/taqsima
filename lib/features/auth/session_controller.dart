import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../data/providers.dart';

/// Holds the signed-in user (null = signed out).
class SessionController extends Notifier<AppUser?> {
  @override
  AppUser? build() => null;

  Future<void> requestOtp(String phone) =>
      ref.read(authRepositoryProvider).requestOtp(phone);

  Future<void> verifyOtp({
    required String phone,
    required String code,
    required UserRole role,
    String? name,
  }) async {
    state = await ref
        .read(authRepositoryProvider)
        .verifyOtp(phone: phone, code: code, role: role, name: name);
  }

  Future<void> updateName(String name) async {
    final user = state;
    if (user == null) return;
    state = await ref.read(userRepositoryProvider).updateName(user.id, name);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = null;
  }
}

final sessionProvider =
    NotifierProvider<SessionController, AppUser?>(SessionController.new);

/// Convenience: the signed-in user's id (throws if signed out).
final currentUserIdProvider =
    Provider<String>((ref) => ref.watch(sessionProvider)!.id);
