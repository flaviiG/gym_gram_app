import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/comment_card.dart';
import 'package:gym_gram_app/providers/comments_provider.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/services/comments_api.dart';
import 'package:gym_gram_app/utils/globals.dart';

class CommentsScreen extends ConsumerWidget {
  CommentsScreen({super.key, required this.postId});

  final String postId;

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    //
    final commentsAsync = ref.watch(commentsProvider(postId));
    final profilePic = ref.read(userProvider)!.photo;

    void createCommentLocal() async {
      if (commentController.text.isNotEmpty) {
        await createComment(postId, commentController.text);
        ref.invalidate(commentsProvider);
        if (!context.mounted) {
          return;
        }
        FocusScope.of(context).unfocus();
        commentController.text = '';
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
        ),
        body: Stack(
          children: [
            commentsAsync.when(
                data: (comments) => ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) =>
                          CommentCard(comment: comments[index]),
                    ),
                error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            '$kBaseStorageUrl/users/$profilePic'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Comment',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                          onPressed: createCommentLocal,
                          icon: const Icon(
                            CupertinoIcons.chat_bubble_text,
                            size: 30,
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
