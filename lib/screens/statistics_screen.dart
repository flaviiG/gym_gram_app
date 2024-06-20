import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_gram_app/screens/statistics/users_statistics.dart';
import 'package:gym_gram_app/screens/statistics/workouts_statistics.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Statistics'),
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const UserStatistics()));
              },
              leading: const Icon(
                CupertinoIcons.person_2,
              ),
              title: const Text(
                'Users',
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(FluentIcons.glance_12_regular),
              title: const Text(
                'Posts',
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const WorkoutsStatistics())),
              leading: const Icon(FluentIcons.dumbbell_16_regular),
              title: const Text(
                'Workouts',
              ),
            ),
          ],
        ));
  }
}
