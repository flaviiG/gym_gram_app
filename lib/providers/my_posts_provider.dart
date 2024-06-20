import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/post.dart';
import 'package:gym_gram_app/services/post_api.dart';
import 'package:image_picker/image_picker.dart';

class MyPostsNotifier extends StateNotifier<List<Post>> {
  MyPostsNotifier() : super([]);

  Future<List<Post>> fetchPosts(String userId) async {
    final List<Post> loadedPosts = await getUserPosts(userId);
    state = loadedPosts;
    return loadedPosts;
  }

  Future<void> createPost(
      String workoutId, XFile image, String description) async {
    final Post? newPost = await createPostApi(workoutId, image, description);
    if (newPost != null) {
      state = [...state, newPost];
    }
  }

  Future<void> deletePost(String postId) async {
    await deletePostApi(postId);

    state = state.where((post) => post.id != postId).toList();
  }

  Future<void> likePost(String postId) async {
    await likePostApi(postId);

    // Update the local state
    state = state.map((post) {
      if (post.id == postId) {
        final updatedLikedBy = List<String>.from(post.likedBy)
          ..add(state[0].user.id);
        return post.copyWith(
          numLikes: post.numLikes + 1,
          likedBy: updatedLikedBy,
        );
      }
      return post;
    }).toList();
  }

  Future<void> unlikePost(String postId) async {
    await unlikePostApi(postId);

    // Update the local state
    state = state.map((post) {
      if (post.id == postId) {
        final updatedLikedBy = List<String>.from(post.likedBy)
          ..remove(state[0].user.id);
        return post.copyWith(
          numLikes: post.numLikes - 1,
          likedBy: updatedLikedBy,
        );
      }
      return post;
    }).toList();
  }
}

final myPostsProvider =
    StateNotifierProvider<MyPostsNotifier, List<Post>>((ref) {
  return MyPostsNotifier();
});

final fetchMyPostsProvider =
    FutureProvider.family.autoDispose<List<Post>, String>((ref, userId) async {
  final postsProvider = ref.read(myPostsProvider.notifier);
  final loadedPosts = postsProvider.fetchPosts(userId);
  return loadedPosts;
});
