import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/post_report.dart';
import 'package:gym_gram_app/services/post_api.dart';
import 'package:gym_gram_app/services/post_reports_api.dart';

class PostReportsNotifier extends StateNotifier<List<PostReport>> {
  PostReportsNotifier() : super([]);

  Future<List<PostReport>> fetchPostReports() async {
    final List<PostReport> loadedReports = await getPostReports();
    state = loadedReports;
    return loadedReports;
  }

  void markPostAsOk(String reportId) async {
    await deleteReport(reportId);

    state = state.where((report) => report.id != reportId).toList();
  }

  void deletePostAndReport(String reportId, String postId) async {
    await deletePostApi(postId);
    await deleteReport(reportId);

    state = state.where((report) => report.id != reportId).toList();
  }
}

final fetchReportsProvider =
    FutureProvider.autoDispose<List<PostReport>>((ref) async {
  final reportsProvider = ref.read(postReportsProvider.notifier);
  final loadedReports = reportsProvider.fetchPostReports();
  return loadedReports;
});

final postReportsProvider =
    StateNotifierProvider<PostReportsNotifier, List<PostReport>>((ref) {
  return PostReportsNotifier();
});
