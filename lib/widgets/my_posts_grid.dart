import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/providers/my_posts_provider.dart';
import 'package:gym_gram_app/screens/post_details_screen.dart';
import 'package:gym_gram_app/utils/globals.dart';
import 'package:gym_gram_app/utils/transparent_route.dart';

class MyPostsGrid extends ConsumerWidget {
  const MyPostsGrid({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(fetchMyPostsProvider(userId));

    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      duration: const Duration(milliseconds: 100),
      child: postsAsync.when(
          data: (_) => Align(
                alignment: Alignment.topLeft,
                child: Consumer(builder: (context, ref, _) {
                  final posts = ref.watch(myPostsProvider);
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {},
                          onTap: () => Navigator.of(context).push(
                            TransparentRoute(
                                builder: (ctx) =>
                                    PostDetailsScreen(post: posts[index])),
                          ),
                          child: CachedNetworkImage(
                            fadeInDuration: const Duration(milliseconds: 100),
                            fit: BoxFit.cover,
                            imageUrl:
                                '$kBaseStorageUrl/posts/${posts[index].user.id}/${posts[index].photo}',
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        );
                      });
                }),
              ),
          error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
          loading: () => const SizedBox()),
    );
  }
}
