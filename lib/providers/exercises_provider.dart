import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/exercise.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/services/exercise_api.dart';

final exerciseProvider = FutureProvider.autoDispose<List<Exercise>>((ref) {
  final userAsyncValue = ref.read(userProvider);

  ref.keepAlive();

  return getExerciseList(userAsyncValue!.username);
});
