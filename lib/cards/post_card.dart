import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/workout_card.dart';
import 'package:gym_gram_app/models/post.dart';
import 'package:gym_gram_app/providers/feed_provider.dart';
import 'package:gym_gram_app/providers/my_posts_provider.dart';
import 'package:gym_gram_app/providers/user_posts_provider.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/screens/comments_screen.dart';
import 'package:gym_gram_app/screens/my_profile_screen.dart';
import 'package:gym_gram_app/screens/profile_screen.dart';
import 'package:gym_gram_app/services/post_reports_api.dart';
import 'package:gym_gram_app/utils/globals.dart';

class PostCard extends ConsumerStatefulWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  //
  //
  late bool _isLiked;
  bool _reporting = false;
  final reportReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.likedBy.contains(ref.read(userProvider)!.id);
  }

  void _sendReport(String reason) async {
    await createPostReport(reason, widget.post.id);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  void _deletePost() async {
    await ref.read(myPostsProvider.notifier).deletePost(widget.post.id);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _openPostOptions() async {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (context, setModalState) {
            return Container(
              color: Colors.black54,
              height: 200,
              width: double.infinity,
              child: _reporting
                  ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Give us the reason',
                          ),
                          controller: reportReasonController,
                          onFieldSubmitted: (String reason) {
                            _sendReport(reason);
                          },
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setModalState(() {
                              _reporting = true;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors
                                      .grey.shade800, // Color of the border
                                  width: 1.0, // Width of the border
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FluentIcons.warning_12_regular,
                                  color: Colors.amber.shade500,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Report',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.amber.shade500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (widget.post.user.id == ref.read(userProvider)!.id ||
                            ref.read(userProvider)!.role == 'admin')
                          InkWell(
                            onTap: _deletePost,
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors
                                        .grey.shade800, // Color of the border
                                    width: 1.0, // Width of the border
                                  ),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FluentIcons.delete_12_regular,
                                    color: CupertinoColors.systemRed,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Delete',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: CupertinoColors.systemRed),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            );
          }),
        );
      },
    );
    setState(() {
      reportReasonController.text = '';
      _reporting = false;
    });
  }

  void _likePost() async {
    final currentUserId = ref.read(userProvider)!.id;
    if (currentUserId == widget.post.user.id) {
      await ref.read(myPostsProvider.notifier).likePost(widget.post.id);
    } else {
      await ref
          .read(userPostsProvider.notifier)
          .likePost(widget.post.id, currentUserId);
    }

    final feedProvider = ref.read(feedAsyncProvider);
    final feedNotifier = ref.read(feedAsyncProvider.notifier);

    feedProvider.whenData((posts) async {
      if (posts.any((post) => post.id == widget.post.id)) {
        print('likeing feed post');
        await feedNotifier.likePost(widget.post.id, currentUserId);
      }
    });

    setState(() {
      _isLiked = true;
    });
  }

  void _unlikePost() async {
    final currentUserId = ref.read(userProvider)!.id;
    if (currentUserId == widget.post.user.id) {
      await ref.read(myPostsProvider.notifier).unlikePost(widget.post.id);
    } else {
      await ref
          .read(userPostsProvider.notifier)
          .unlikePost(widget.post.id, currentUserId);
    }

    final feedProvider = ref.read(feedAsyncProvider);
    final feedNotifier = ref.read(feedAsyncProvider.notifier);

    feedProvider.whenData((posts) async {
      if (posts.any((post) => post.id == widget.post.id)) {
        await feedNotifier.unlikePost(widget.post.id, currentUserId);
      }
    });

    setState(() {
      _isLiked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 2,
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      child: SizedBox(
        height: 710,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 32,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ref.read(userProvider)!.id ==
                                          widget.post.user.id
                                      ? const MyProfileScreen()
                                      : ProfileScreen(
                                          userId: widget.post.user.id,
                                          username: widget.post.user.username,
                                        ),
                            ));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                '$kBaseStorageUrl/users/${widget.post.user.photo}'),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(
                              widget.post.user.username,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: _openPostOptions,
                        icon: const Icon(
                          CupertinoIcons.ellipsis_vertical,
                          size: 20,
                        ))
                  ]),
            ),
            GestureDetector(
              onDoubleTap: () {},
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 100),
                  fadeInCurve: Curves.easeOut,
                  fit: BoxFit.cover,
                  imageUrl:
                      '$kBaseStorageUrl/posts/${widget.post.user.id}/${widget.post.photo}',
                ),
              ),
            ),
            WorkoutCard(
              workout: widget.post.workout,
              isSelectable: false,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                widget.post.description,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: GestureDetector(
                              onTap: _isLiked ? _unlikePost : _likePost,
                              child: Icon(
                                _isLiked
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                size: 30,
                                color: _isLiked ? Colors.red : Colors.white,
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => CommentsScreen(
                                        postId: widget.post.id)));
                              },
                              child: const Icon(CupertinoIcons.chat_bubble,
                                  size: 30)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        children: [
                          Text(
                            widget.post.numLikes.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'FjallaOne',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.numLikes == 1 ? 'Like' : 'Likes',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.post.numComments.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'FjallaOne',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.numComments == 1
                                ? 'Comment'
                                : 'Comments',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
