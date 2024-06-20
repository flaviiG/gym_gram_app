import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/screens/my_profile_screen.dart';
import 'package:gym_gram_app/screens/profile_screen.dart';
import 'package:gym_gram_app/services/user_api.dart';
import 'package:gym_gram_app/utils/globals.dart';

class UserStatistics extends ConsumerStatefulWidget {
  const UserStatistics({super.key});

  @override
  ConsumerState<UserStatistics> createState() => _UserStatisticsState();
}

class _UserStatisticsState extends ConsumerState<UserStatistics> {
  //
  //
  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _users = getTopUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User statistics'),
        ),
        body: RefreshIndicator(
          onRefresh: () async => setState(() {
            _users = getTopUsers();
          }),
          child: ListView(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade800, // Color of the border
                      width: 1.0, // Width of the border
                    ),
                  ),
                ),
                child: const Text(
                  'Most popular users',
                  style: TextStyle(fontSize: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: FutureBuilder(
                    future: _users,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const LinearProgressIndicator();
                      }
                      return Column(children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: BarChart(
                            BarChartData(
                              barGroups: [
                                for (int i = 0; i < snapshot.data!.length; i++)
                                  BarChartGroupData(
                                    x: i + 1,
                                    barRods: [
                                      BarChartRodData(
                                        color: CupertinoColors.activeBlue,
                                        toY: snapshot.data![i].numFollowers
                                            .toDouble(),
                                      )
                                    ],
                                  ),
                              ],
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt() - 1;
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        space:
                                            5, // Add space to customize the position
                                        child: SizedBox(
                                          width: 45,
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            snapshot.data![index].username,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    interval: 1,
                                    showTitles: true,
                                  ),
                                  axisNameWidget: Text(
                                    'Number of Followers',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    interval: 1,
                                    showTitles: false,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    interval: 1,
                                    showTitles: false,
                                  ),
                                ),
                              ),
                            ),
                            swapAnimationDuration:
                                const Duration(milliseconds: 600),
                            swapAnimationCurve: Curves.easeOut,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            for (int i = 0; i < snapshot.data!.length; i++)
                              ListTile(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (ctx) => ref
                                                    .read(userProvider)!
                                                    .id ==
                                                snapshot.data![i].id
                                            ? const MyProfileScreen()
                                            : ProfileScreen(
                                                userId: snapshot.data![i].id,
                                                user: snapshot.data![i],
                                              ))),
                                leading: Text(
                                  '${i + 1}.',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                title: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: CachedNetworkImageProvider(
                                            '$kBaseStorageUrl/users/${snapshot.data![i].photo}'),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(snapshot.data![i].username)
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      ]);
                    }),
              )
            ],
          ),
        ));
  }
}
