import 'package:dio/dio.dart';
import 'package:gym_gram_app/models/post_report.dart';
import 'package:gym_gram_app/utils/globals.dart';

const baseUrl = 'http://10.0.2.2:8080/api/v1/postReports';

final dio = Dio();

Future<List<PostReport>> getPostReports() async {
//
//
  final String? jwt = await storage.read(key: "jwt");

  try {
    Response response = await dio.get(baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
          },
        ));

    final reportsData = response.data['data']['postReports'];
    if (reportsData.isEmpty) {
      return [];
    }

    print(reportsData);

    final List<PostReport> reports = reportsData
        .map<PostReport>((reportJson) => PostReport.fromJson(reportJson))
        .toList();

    return reports;
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}

Future<void> deleteReport(String reportId) async {
  //
  //
  final String? jwt = await storage.read(key: "jwt");

  try {
    await dio.delete('$baseUrl/$reportId',
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

Future<void> createPostReport(String reason, String postId) async {
  //
  //
  final String? jwt = await storage.read(key: "jwt");

  try {
    await dio.post(baseUrl,
        data: {
          'postReport': {'post': postId, 'reason': reason}
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt',
          },
        ));
  } on DioException catch (e) {
    print(e.response);
    throw Exception(e.response!.data['message']);
  }
}
