import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/comment.dart';
import 'package:gym_gram_app/services/post_api.dart';

final commentsProvider =
    FutureProvider.family.autoDispose<List<Comment>, String>((ref, postId) {
  return getPostComments(postId);
});
