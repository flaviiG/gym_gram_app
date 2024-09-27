import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/services/user_api.dart';
import 'package:gym_gram_app/services/workout_api.dart';

final workoutsProvider = FutureProvider.autoDispose<List<Workout>>((ref) {
  return getMyWorkouts();
});

// TODO: Convert to AsyncNotifier and update the local state when creating and removing workouts

class MyWorkouts extends AutoDisposeAsyncNotifier<List<Workout>> {
  @override
  FutureOr<List<Workout>> build() {
    return getMyWorkouts();
  }

  Future<void> createWorkout(Workout workout) async {
    // Update the local state
    print('saving workout');

    // await createWorkoutApi(workout);

    await update(
      (previousState) {
        previousState.add(workout);
        return previousState;
      },
    );
  }

  Future<void> removeWorkout(Workout workout) async {
    // Update the local state
    print('unsaving workout');

    // await removeWorkout(workout.id);

    await update(
      (previousState) {
        previousState.remove(workout);
        return previousState;
      },
    );
  }
}

class SavedWorkouts extends AutoDisposeAsyncNotifier<List<Workout>> {
  @override
  FutureOr<List<Workout>> build() {
    return getMySavedWorkouts();
  }

  Future<void> saveWorkout(Workout workout) async {
    // Update the local state
    print('saving workout');

    await saveWorkoutApi(workout.id);

    await update(
      (previousState) {
        final newState = [...previousState]..add(workout);
        return newState;
      },
    );
  }

  Future<void> removeSavedWorkout(Workout workout) async {
    // Update the local state
    print('unsaving workout');

    await removeSavedWorkoutApi(workout.id);

    await update(
      (previousState) {
        final newState = [...previousState]
          ..removeWhere((w) => w.id == workout.id);
        return newState;
      },
    );
  }
}

final savedWorkoutsAsyncProvider =
    AsyncNotifierProvider.autoDispose<SavedWorkouts, List<Workout>>(
        SavedWorkouts.new);
