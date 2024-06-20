import 'package:gym_gram_app/models/user.dart';

class Comment {
  Comment({required this.commentText, required this.user, required this.date});

  final String commentText;
  final ShortUser user;
  final String date;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        commentText: json['commentText'],
        user: ShortUser.fromJson(json['user']),
        date: json['date']);
  }
}
