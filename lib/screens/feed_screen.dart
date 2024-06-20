import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/post_card.dart';
import 'package:gym_gram_app/providers/feed_provider.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('Building feedScreen');
    final postsAsync = ref.watch(feedAsyncProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(feedAsyncProvider.notifier).refreshFeed();
        },
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          duration: const Duration(milliseconds: 600),
          child: postsAsync.when(
              data: (posts) => ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      // print('Building card $index');
                      return PostCard(key: UniqueKey(), post: posts[index]);
                    },
                  ),
              error: (error, stackTrace) {
                print(stackTrace);
                return Center(
                  child: Text(error.toString()),
                );
              },
              loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )),
        ),
      ),
    );
  }
}
