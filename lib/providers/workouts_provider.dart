import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/services/user_api.dart';
import 'package:gym_gram_app/services/workout_api.dart';

final workoutsProvider = FutureProvider.autoDispose<List<Workout>>((ref) {
  return getMyWorkouts();
});

final savedWorkoutsProvider = FutureProvider.autoDispose<List<Workout>>((ref) {
  return getMySavedWorkouts();
});
