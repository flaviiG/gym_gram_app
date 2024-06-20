import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/profile_card.dart';
import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/widgets/posts_grid.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen(
      {super.key, this.user, this.username, required this.userId});

  final User? user;
  final String userId;
  final String? username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return user != null
        ? Scaffold(
            appBar: AppBar(
              title: Text('${user!.username}\'s profile'),
            ),
            body: Column(
              children: [
                ProfileCard(user: user!),
                const SizedBox(height: 10),
                Expanded(
                    child: PostsGrid(
                  userId: userId,
                ))
              ],
            ),
          )
        : Scaffold(
            appBar: username != null
                ? AppBar(
                    title: Text('$username\'s profile'),
                  )
                : null,
            body: Consumer(builder: (context, ref, _) {
              final userAsync = ref.watch(fetchUserProfileProvider(userId));
              return userAsync.when(
                  data: (user) => Column(children: [
                        ProfileCard(user: user!),
                        const SizedBox(height: 10),
                        Expanded(
                            child: PostsGrid(
                          userId: userId,
                        ))
                      ]),
                  error: (error, stackTrace) => Center(
                        child: Text(error.toString()),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ));
            }),
          );
  }
}
