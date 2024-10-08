import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/post.dart';
import 'package:gym_gram_app/services/post_api.dart';

class UserPostsNotifier extends StateNotifier<List<Post>> {
  UserPostsNotifier() : super([]);

  Future<List<Post>> fetchPosts(String userId) async {
    final List<Post> loadedPosts = await getUserPosts(userId);
    state = loadedPosts;
    return loadedPosts;
  }

  Future<void> likePost(String postId, String currentUserId) async {
    likePostApi(postId);

    if (state.isEmpty) {
      return;
    }
    // Update the local state
    state = state.map((post) {
      if (post.id == postId) {
        final updatedLikedBy = List<String>.from(post.likedBy)
          ..add(currentUserId);
        return post.copyWith(
          numLikes: post.numLikes + 1,
          likedBy: updatedLikedBy,
        );
      }
      return post;
    }).toList();
  }

  Future<void> unlikePost(String postId, String currentUserId) async {
    unlikePostApi(postId);

    if (state.isEmpty) {
      return;
    }

    // Update the local state
    state = state.map((post) {
      if (post.id == postId) {
        final updatedLikedBy = List<String>.from(post.likedBy)
          ..remove(currentUserId);
        return post.copyWith(
          numLikes: post.numLikes - 1,
          likedBy: updatedLikedBy,
        );
      }
      return post;
    }).toList();
  }

  void updateNumComments(String postId, int numComments) {
    print('DEBUG::::::::::updating num commetnss');
    state = state
        .map((post) =>
            post.id == postId ? post.copyWith(numComments: numComments) : post)
        .toList();
  }
}

final userPostsProvider =
    StateNotifierProvider<UserPostsNotifier, List<Post>>((ref) {
  return UserPostsNotifier();
});

final fetchUserPostsProvider =
    FutureProvider.family.autoDispose<List<Post>, String>((ref, userId) async {
  final postsProvider = ref.read(userPostsProvider.notifier);
  final loadedPosts = postsProvider.fetchPosts(userId);
  return loadedPosts;
});
