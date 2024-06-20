import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/services/auth_api.dart';
import 'package:gym_gram_app/services/user_api.dart';
import 'package:gym_gram_app/utils/globals.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Future<User?> fetchUser({bool isInit = false}) async {
    final jwt = await storage.read(key: 'jwt');
    if (jwt != null) {
      final user = await getUser(jwt, isInit);
      state = user;
      return user;
    }
    return null;
  }

  void logout() async {
    await storage.delete(key: "jwt");
    state = null;
  }

  void saveWorkout(String workoutId) async {
    await saveWorkoutApi(workoutId);
    final updatedUser = state!.copyWith(savedWorkouts: [
      ...state!.savedWorkouts,
      workoutId,
    ]);
    state = updatedUser;
  }

  void removeSavedWorkout(String workoutId) async {
    await removeSavedWorkoutApi(workoutId);
    final updatedUser = state!.copyWith(savedWorkouts: [
      ...state!.savedWorkouts..remove(workoutId),
    ]);
    state = updatedUser;
  }
}

final fetchUserProvider =
    FutureProvider.family<User?, bool>((ref, isInit) async {
  final userNotifier = ref.read(userProvider.notifier);
  final user = userNotifier.fetchUser(isInit: isInit);
  return user;
});

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

final fetchUserProfileProvider =
    FutureProvider.family.autoDispose<User?, String>((ref, userId) async {
  return getUserProfile(userId);
});
