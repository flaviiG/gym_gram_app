import 'dart:convert';
import 'package:gym_gram_app/models/user.dart';
import 'package:http/http.dart' as http;

const baseUrl = '10.0.2.2:8080';

class AuthApi {
  Future<String?> login(String username, String password) async {
    //
    final url = Uri.http(
      baseUrl,
      'api/v1/users/login',
    );

    final res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {'username': username, 'password': password},
        ));

    final data = json.decode(res.body);

    if (data['status'] != 'success') {
      throw Exception(data['message']);
    }

    return data['token'];
  }

  Future<String?> register(
    String email,
    String username,
    String password,
  ) async {
    //
    final url = Uri.http(
      baseUrl,
      'api/v1/users/signup',
    );

    final res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
            'username': username,
            'password': password,
          },
        ));

    final data = json.decode(res.body);

    if (data['status'] != 'success') {
      print(data);

      throw Exception(data['message']);
    }

    return data['token'];
  }
}

Future<User> getUser(String jwt, bool isInit) async {
  print('Getting user');

  final url = Uri.http(
    baseUrl,
    'api/v1/users/getUser',
  );

  final res = await http.get(
    url,
    headers: {'Authorization': 'Bearer $jwt'},
  );

  final data = json.decode(res.body);

  if (data['status'] != 'success') {
    throw Exception(data['message']);
  }
  print(data['data']['user']);

  if (isInit) {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  return User.fromJson(data['data']['user']);
}
