import 'package:gym_gram_app/utils/globals.dart';
import 'package:gym_gram_app/models/workout.dart';

import 'package:dio/dio.dart';

final dio = Dio();

const baseUrl = 'http://10.0.2.2:8080/api/v1/workouts';

Future<List<Workout>> getMyWorkouts() async {
  //
  String? jwt = await storage.read(key: "jwt");

  print('Getting workouts');

  final response = await dio.get(
    '$baseUrl/myWorkouts',
    options: Options(
      headers: {'Authorization': 'Bearer $jwt'},
    ),
  );

  final data = response.data;

  print(data);

  if (data['status'] != 'success') {
    throw Exception('Failed to fetch workouts');
  }

  final workoutsData = data['data']['workouts'] as List;
  if (workoutsData.isEmpty) {
    return [];
  }
  final List<Workout> workouts =
      workoutsData.map((workoutJson) => Workout.fromJson(workoutJson)).toList();

  return workouts;
}

Future<void> createWorkout(
    String workoutName, Map<String, List<Set>> exercises) async {
  //
  //

  String? jwt = await storage.read(key: "jwt");

  // Transform the exercises map to JSON structure
  List<Map<String, dynamic>> exerciseList = exercises.entries.map((entry) {
    return {
      'exercise': entry.key,
      'sets': entry.value.map((set) => set.toJson()).toList(),
    };
  }).toList();

  final response = await dio.post(baseUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'workout': {'name': workoutName, 'exercises': exerciseList},
      });

  print(response.data);
}

Future<List<Workout>> getMostSavedWorkouts() async {
  //
  String? jwt = await storage.read(key: "jwt");

  print('Getting most saved workouts');
  try {
    final response = await dio.get(
      '$baseUrl/mostSaved',
      options: Options(
        headers: {'Authorization': 'Bearer $jwt'},
      ),
    );

    final data = response.data;

    final workoutsData = data['data']['workouts'] as List;
    print(workoutsData);
    if (workoutsData.isEmpty) {
      return [];
    }
    final List<Workout> workouts = workoutsData
        .map((workoutJson) => Workout.fromJson(workoutJson))
        .toList();

    print(workouts);
    return workouts;
  } on DioException catch (e) {
    print(e.response);
    throw Exception('Failed to fetch workouts');
  }
}
