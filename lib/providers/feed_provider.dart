import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/post.dart';
import 'package:gym_gram_app/services/post_api.dart';

class Feed extends AutoDisposeAsyncNotifier<List<Post>> {
  @override
  FutureOr<List<Post>> build() {
    return getFeed();
  }

// TODO: Show only new posts - update the viewedPosts array
  Future<void> refreshFeed() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => getFeed());
  }

  Future<void> likePost(String postId, String userId) async {
    // Update the local state
    print('in the feedProider liking a post');

    await update(
      (previousState) {
        final newState = previousState.map((post) {
          if (post.id == postId) {
            final updatedLikedBy = List<String>.from(post.likedBy)..add(userId);
            return post.copyWith(
              numLikes: post.numLikes + 1,
              likedBy: updatedLikedBy,
            );
          }
          return post;
        }).toList();
        return newState;
      },
    );
  }

  Future<void> unlikePost(String postId, String userId) async {
    // Update the local state
    state = state.whenData((posts) {
      return posts.map((post) {
        if (post.id == postId) {
          final updatedLikedBy = List<String>.from(post.likedBy)
            ..remove(userId);
          return post.copyWith(
            numLikes: post.numLikes - 1,
            likedBy: updatedLikedBy,
          );
        }
        return post;
      }).toList();
    });
  }

  Future<void> updateNumComments(String postId, int numComments) async {
    // Update the local state
    await update(
      (previousState) {
        if (!previousState.any((p) => p.id == postId)) {
          return previousState;
        }
        final newState = previousState.map((post) {
          if (post.id == postId) {
            return post.copyWith(
              numComments: numComments,
            );
          }
          return post;
        }).toList();
        return newState;
      },
    );
  }
}

final feedAsyncProvider =
    AsyncNotifierProvider.autoDispose<Feed, List<Post>>(Feed.new);
