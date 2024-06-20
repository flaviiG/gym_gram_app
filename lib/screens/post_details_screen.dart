import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gym_gram_app/cards/post_card.dart';
import 'package:gym_gram_app/models/post.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
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
                post: post,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
