import 'package:gym_gram_app/models/exercise.dart';

import 'package:dio/dio.dart';
import 'package:gym_gram_app/utils/globals.dart';

const baseUrl = '$kApiBaseUrl/exercises';

final dio = Dio();

Future<List<Exercise>> getExerciseList(String username) async {
  Response response;

  response = await dio.get(
    baseUrl,
    queryParameters: {
      'createdBy': 'GymGram',
    },
  );

  print(response.data['data']['exercises']);

  final exerciseData = response.data['data']['exercises'] as List;

  if (exerciseData.isEmpty) {
    return [];
  }

  final List<Exercise> exercises = exerciseData
      .map((exerciseJson) => Exercise.fromJson(exerciseJson))
      .toList();

  return exercises;
}
