import 'package:dio/dio.dart';
import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/utils/globals.dart';

const baseUrl = '$kApiBaseUrl/users';

final dio = Dio();

Future<String?> login(String username, String password) async {
  try {
    final response = await dio.post('$baseUrl/login', data: {
      'username': username,
      'password': password,
    });

    final data = response.data;

    if (data['status'] != 'success') {
      throw Exception(data['message']);
    }

    return data['token'];
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'An error occurred');
  }
}

Future<String?> register(String email, String username, String password) async {
  try {
    final response = await dio.post('$baseUrl/signup', data: {
      'email': email,
      'username': username,
      'password': password,
    });

    final data = response.data;

    if (data['status'] != 'success') {
      print(data);
      throw Exception(data['message']);
    }

    return data['token'];
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'An error occurred');
  }
}

Future<User?> getUser() async {
  print('Getting user');

  final jwt = await storage.read(key: 'jwt');

  if (jwt == null) {
    return null;
  }

  try {
    final response = await dio.get(
      '$baseUrl/getUser',
      options: Options(headers: {'Authorization': 'Bearer $jwt'}),
    );

    final data = response.data;

    if (data['status'] != 'success') {
      throw Exception(data['message']);
    }
    print(data['data']['user']);

    return User.fromJson(data['data']['user']);
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'An error occurred');
  }
}
