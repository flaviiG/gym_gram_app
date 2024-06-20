import 'package:gym_gram_app/models/exercise.dart';

import 'package:dio/dio.dart';

const baseUrl = 'http://10.0.2.2:8080';

final dio = Dio();

Future<List<Exercise>> getExerciseList(String username) async {
  Response response;

  response = await dio.get(
    '$baseUrl/api/v1/exercises',
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
