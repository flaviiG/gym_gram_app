import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/workout_card.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/providers/workouts_provider.dart';
import 'package:gym_gram_app/screens/add_workout_screen.dart';

class WorkoutsScreen extends ConsumerStatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  ConsumerState<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends ConsumerState<WorkoutsScreen> {
  List<Workout> workouts = [];

  @override
  Widget build(BuildContext context) {
    final workoutsAsync = ref.watch(workoutsProvider);
    final savedWorkoutsAsync = ref.watch(savedWorkoutsAsyncProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('My workouts'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const AddWorkoutScreen()));
                  },
                  icon: const Icon(CupertinoIcons.add_circled))
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(CupertinoIcons.rectangle_stack_badge_person_crop),
                  child: Text('By me'),
                ),
                Tab(
                  icon: Icon(CupertinoIcons.bookmark_fill),
                  child: Text('Saved'),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            workoutsAsync.when(
                data: (workouts) => ListView(
                      children: [
                        ...workouts.map((w) => WorkoutCard(
                              workout: w,
                              isSelectable: false,
                            )),
                      ],
                    ),
                error: (err, stack) {
                  print(stack);
                  return Center(
                    child: Text(err.toString()),
                  );
                },
                loading: () => const LinearProgressIndicator()),
            savedWorkoutsAsync.when(
                data: (workouts) => ListView(
                      children: [
                        ...workouts.map((w) => WorkoutCard(
                              workout: w,
                              isSelectable: false,
                            )),
                      ],
                    ),
                error: (err, stack) {
                  print(stack);
                  return Center(
                    child: Text(err.toString()),
                  );
                },
                loading: () => const LinearProgressIndicator()),
          ])),
    );
  }
}
