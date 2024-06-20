import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_gram_app/cards/workout_card.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/services/workout_api.dart';

class WorkoutsStatistics extends StatefulWidget {
  const WorkoutsStatistics({super.key});

  @override
  State<WorkoutsStatistics> createState() => _WorkoutsStatisticsState();
}

class _WorkoutsStatisticsState extends State<WorkoutsStatistics> {
  //
  late Future<List<Workout>> _workouts;

  @override
  void initState() {
    super.initState();
    _workouts = getMostSavedWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Workouts statistics'),
        ),
        body: RefreshIndicator(
          onRefresh: () async => setState(() {
            _workouts = getMostSavedWorkouts();
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
                  'Most saved workouts',
                  style: TextStyle(fontSize: 26),
                ),
              ),
              FutureBuilder(
                  future: _workouts,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const LinearProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: AspectRatio(
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
                                        toY: snapshot.data![i].numSaves!
                                            .toDouble(),
                                      )
                                    ],
                                  ),
                              ],
                              titlesData: const FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    interval: 1,
                                    showTitles: true,
                                  ),
                                  axisNameWidget: Text(
                                    'Number of users that saved the workout',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    interval: 1,
                                    showTitles: false,
                                  ),
                                ),
                                topTitles: AxisTitles(
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
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            for (int i = 0; i < snapshot.data!.length; i++)
                              Row(
                                children: [
                                  Text(
                                    '${i + 1}.',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: WorkoutCard(
                                      workout: snapshot.data![i],
                                      isSelectable: false,
                                    ),
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
                    ]);
                  }),
            ],
          ),
        ));
  }
}
