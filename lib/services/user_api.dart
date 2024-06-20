import 'package:dio/dio.dart';
import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/utils/globals.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

const baseUrl = 'http://10.0.2.2:8080/api/v1/users';

final dio = Dio();

Future<List<ShortUser>> searchUser(searchValue) async {
  //
  //

  final String? jwt = await storage.read(key: "jwt");

  final response = await dio.get('$baseUrl/searchUser/$searchValue',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      ));

  final userData = response.data['data']['users'] as List;

  print(userData);

  if (userData.isEmpty) {
    return [];
  }

  return userData.map((userJson) => ShortUser.fromJson(userJson)).toList();
}

Future<void> followUser(userId) async {
  //
  //
  final String? jwt = await storage.read(key: "jwt");

  Response response = await dio.post('$baseUrl/followUser/$userId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
        },
      ));
  print(response);
}

Future<void> unfollowUser(userId) async {
  //
  //

  final String? jwt = await storage.read(key: "jwt");

  Response response = await dio.post('$baseUrl/unfollowUser/$userId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $jwt',
        },
      ));
  print(response);
}

Future<bool> changeProfilePic(XFile image) async {
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 3);
  try {
    final String? jwt = await storage.read(key: "jwt");
    // Create FormData with the image file
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(image.path,
          contentType: MediaType('image', 'jpg')),
    });

    // Send POST request
    await dio.patch(
      '$baseUrl/updateMe',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization':
              'Bearer $jwt', // Replace with your JWT token if required
        },
      ),
    );
  } on DioException catch (e) {
    print('Upload failed: ${e.response!.data['message']}');
    return false;
  }
  return true;
}

Future<User> getUserProfile(userId) async {
  final String? jwt = await storage.read(
    key: "jwt",
  );

  try {
    Response response = await dio.get(
      '$baseUrl/$userId',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $jwt', // Replace with your JWT token if required
        },
      ),
    );
    return User.fromJson(response.data['data']['user']);
  } on DioException catch (e) {
    throw Exception(e.response!.data['message']);
  }
}

Future<void> saveWorkoutApi(String workoutId) async {
  //
  //
  final String? jwt = await storage.read(
    key: "jwt",
  );

  try {
    await dio.post(
      '$baseUrl/saveWorkout',
      data: {'workout': workoutId},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $jwt', // Replace with your JWT token if required
        },
      ),
    );
  } on DioException catch (e) {
    throw Exception(e.response!.data['message']);
  }
}

Future<void> removeSavedWorkoutApi(String workoutId) async {
  //
  //
  final String? jwt = await storage.read(
    key: "jwt",
  );

  try {
    await dio.post(
      '$baseUrl/removeSavedWorkout',
      data: {'workout': workoutId},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $jwt', // Replace with your JWT token if required
        },
      ),
    );
  } on DioException catch (e) {
    throw Exception(e.response!.data['message']);
  }
}

Future<List<Workout>> getMySavedWorkouts() async {
  //
  String? jwt = await storage.read(key: "jwt");

  print('Getting saved workouts');

  final response = await dio.get(
    '$baseUrl/savedWorkouts',
    options: Options(
      headers: {'Authorization': 'Bearer $jwt'},
    ),
  );

  final data = response.data;

  print(data);

  if (data['status'] != 'success') {
    throw Exception('Failed to fetch workouts');
  }

  final workoutsData = data['data']['savedWorkouts'] as List;
  if (workoutsData.isEmpty) {
    return [];
  }
  final List<Workout> workouts =
      workoutsData.map((workoutJson) => Workout.fromJson(workoutJson)).toList();

  return workouts;
}

Future<List<User>> getTopUsers() async {
  final String? jwt = await storage.read(
    key: "jwt",
  );

  print('Getting top users');

  try {
    Response response = await dio.get(
      '$baseUrl/mostPopular',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $jwt', // Replace with your JWT token if required
        },
      ),
    );
    final data = response.data;
    print(data);
    final userData = data['data']['users'] as List;
    if (userData.isEmpty) {
      return [];
    }
    final List<User> users =
        userData.map((userJson) => User.fromJson(userJson)).toList();

    print(users);
    return users;
  } on DioException catch (e) {
    throw Exception(e.response!.data['message']);
  }
}
