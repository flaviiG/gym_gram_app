import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/screens/login_screen.dart';
import 'package:gym_gram_app/screens/post_reports_screen.dart';
import 'package:gym_gram_app/screens/statistics_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            if (ref.read(userProvider)!.role == 'admin')
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const PostReportsScreen()));
                },
                leading: const Icon(
                  FluentIcons.warning_12_regular,
                ),
                title: const Text(
                  'Post reports',
                ),
              ),
            if (ref.read(userProvider)!.role == 'admin')
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const StatisticsScreen()));
                },
                leading: const Icon(
                  FluentIcons.chart_multiple_16_regular,
                ),
                title: const Text(
                  'Statistics',
                ),
              ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
                ref.read(userProvider.notifier).logout();
                // ref.invalidate(feedAsyncProvider);
              },
              leading: const Icon(
                FluentIcons.arrow_circle_left_12_regular,
                color: Colors.red,
              ),
              title: const Text(
                'Log out',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }
}
