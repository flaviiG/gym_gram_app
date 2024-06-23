import 'package:dio/dio.dart';
import 'package:gym_gram_app/models/comment.dart';
import 'package:gym_gram_app/models/post.dart';
import 'package:gym_gram_app/utils/globals.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

const baseUrl = '$kApiBaseUrl/posts';

final dio = Dio();

Future<List<Post>> getFeed() async {
  //
  //
  print('Getting feed');

  final String? jwt = await storage.read(key: 'jwt');

  if (jwt == null) {
    return [];
  }

  try {
    Response response = await dio.get('$baseUrl/getFeed',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
          },
        ));

    final postData = response.data['data']['posts'];
    if (postData.isEmpty) {
      return [];
    }

    final List<Post> posts = postData
        .map<Post>((workoutJson) => Post.fromJson(workoutJson))
        .toList();

    return posts;
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}

Future<void> likePostApi(String postId) async {
  //
  //
  final String? jwt = await storage.read(key: "jwt");

  try {
    await dio.patch('$baseUrl/like/$postId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
          },
        ));
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}

Future<void> unlikePostApi(String postId) async {
  //
  //
  final String? jwt = await storage.read(key: "jwt");

  try {
    await dio.patch('$baseUrl/unlike/$postId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
          },
        ));
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}

Future<List<Comment>> getPostComments(String postId) async {
  //
  //
  final String? jwt = await storage.read(key: "jwt");

  try {
    Response response = await dio.get('$baseUrl/$postId/comments',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
          },
        ));

    final commentsData = response.data['data']['comments'];
    if (commentsData.isEmpty) {
      return [];
    }

    print(commentsData);

    final List<Comment> comments = commentsData
        .map<Comment>((commentJson) => Comment.fromJson(commentJson))
        .toList();

    return comments;
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}

Future<List<Post>> getUserPosts(String userId) async {
  //
  //
  print('Getting posts');

  final String? jwt = await storage.read(key: "jwt");

  try {
    Response response = await dio.get('$baseUrl?userId=$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
          },
        ));

    final postData = response.data['data']['posts'];
    if (postData.isEmpty) {
      return [];
    }

    print(postData);

    final List<Post> posts =
        postData.map<Post>((postJson) => Post.fromJson(postJson)).toList();

    return posts;
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}

Future<Post?> createPostApi(
    String workoutId, XFile image, String description) async {
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 3);
  try {
    final String? jwt = await storage.read(key: "jwt");
    // Create FormData with the image file
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(image.path,
          contentType: MediaType('image', 'jpg')),
      'description': description,
      'workout': workoutId,
    });

    // Send POST request
    final response = await dio.post(
      baseUrl,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization':
              'Bearer $jwt', // Replace with your JWT token if required
        },
      ),
    );

    final data = response.data;

    return Post.fromJson(data['data']['post']);
  } on DioException catch (e) {
    print('Upload failed: ${e.response!.data['message']}');
  }
  return null;
}

Future<void> deletePostApi(String postId) async {
  //
  //
  final String? jwt = await storage.read(key: "jwt");

  try {
    await dio.delete('$baseUrl/$postId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
          },
        ));
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}
