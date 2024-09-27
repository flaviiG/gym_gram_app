import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/post_card.dart';
import 'package:gym_gram_app/models/post.dart';
import 'package:gym_gram_app/providers/my_posts_provider.dart';
import 'package:gym_gram_app/providers/user_posts_provider.dart';

class PostDetailsScreen extends ConsumerWidget {
  const PostDetailsScreen(
      {super.key, required this.postId, required this.myPost, this.post});

  final String postId;
  final bool myPost;
  final Post? post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = post != null
        ? null
        : myPost
            ? ref.watch(myPostsProvider)
            : ref.watch(userPostsProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.transparent,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10, sigmaY: 10), // Adjust blur intensity
                child: Container(
                  color: Colors.black
                      .withOpacity(0.2), // Adjust the opacity of the background
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: PostCard(
                post: posts?.firstWhere((p) => p.id == postId) ?? post!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
