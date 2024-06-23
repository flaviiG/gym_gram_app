import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/my_profile_card.dart';
import 'package:gym_gram_app/providers/my_posts_provider.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/screens/settings_screen.dart';
import 'package:gym_gram_app/widgets/my_posts_grid.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  void _openSetting(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My profile'),
          actions: [
            IconButton(
                onPressed: () {
                  _openSetting(context);
                },
                icon: const Icon(FluentIcons.settings_16_regular))
          ],
        ),
        body: user == null
            ? const SizedBox()
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(fetchUserProvider);
                  ref.invalidate(fetchMyPostsProvider);
                },
                child: ListView(children: [
                  const MyProfileCard(),
                  const SizedBox(
                    height: 10,
                  ),
                  MyPostsGrid(
                    userId: user.id,
                  )
                ]),
              ));
  }
}
