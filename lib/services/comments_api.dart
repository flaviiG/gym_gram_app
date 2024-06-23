import 'package:dio/dio.dart';
import 'package:gym_gram_app/utils/globals.dart';

const baseUrl = '$kApiBaseUrl/comments';

final dio = Dio();

Future<void> createComment(String postId, String commentText) async {
  //
  //
  final String? jwt = await storage.read(key: "jwt");

  try {
    await dio.post(baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'postId': postId,
          'comment': {'commentText': commentText}
        });
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}
