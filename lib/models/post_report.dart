import 'package:gym_gram_app/models/post.dart';
import 'package:gym_gram_app/models/user.dart';

class PostReport {
  PostReport(
      {required this.id,
      required this.post,
      required this.reason,
      required this.reportedBy});

  final String id;
  final String reason;
  final Post post;
  final ShortUser reportedBy;

  factory PostReport.fromJson(Map<String, dynamic> json) {
    return PostReport(
        id: json['_id'] as String,
        reason: json['reason'] as String,
        post: Post.fromJson(json['post']),
        reportedBy: ShortUser.fromJson(json['reportedBy']));
  }
}
