import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/post_card.dart';
import 'package:gym_gram_app/providers/feed_provider.dart';
import 'package:gym_gram_app/providers/user_provider.dart';

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
          child: ref.read(userProvider)!.numFollowing == 0
              ? const NoFollowingNote()
              : postsAsync.when(
                  data: (posts) => posts.isEmpty
                      ? const NoNewPostsNote()
                      : ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            // print('Building card $index');
                            return PostCard(
                                key: UniqueKey(), post: posts[index]);
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

class NoFollowingNote extends StatelessWidget {
  const NoFollowingNote({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: SizedBox(
            height: 100,
            width: 240,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.emoji_add_16_regular,
                      size: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('So empty here...'),
                        Text('Maybe follow someone'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoNewPostsNote extends StatelessWidget {
  const NoNewPostsNote({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: SizedBox(
            height: 100,
            width: 240,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.checkmark_12_regular,
                      size: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nothing new here...'),
                        Text('You are up to date'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
