import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/services/auth_api.dart';
import 'package:gym_gram_app/services/user_api.dart';
import 'package:gym_gram_app/utils/globals.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Future<User?> fetchUser() async {
    final user = await getUser();
    state = user;
    return user;
  }

  void logout() async {
    await storage.delete(key: "jwt");
    state = null;
  }
}

final fetchUserProvider = FutureProvider.autoDispose<User?>((ref) async {
  final userNotifier = ref.read(userProvider.notifier);
  final user = userNotifier.fetchUser();
  return user;
});

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

final fetchUserProfileProvider =
    FutureProvider.family.autoDispose<User?, String>((ref, userId) async {
  return getUserProfile(userId);
});
