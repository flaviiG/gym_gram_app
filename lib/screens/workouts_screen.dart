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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.rectangle_stack_badge_person_crop,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'By me',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.bookmark_fill),
                      SizedBox(width: 10),
                      Text(
                        'Saved',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            workoutsAsync.when(
              data: (workouts) => ListView(
                children: [
                  const SizedBox(height: 5),
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
              loading: () => const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
            savedWorkoutsAsync.when(
              data: (workouts) => ListView(
                children: [
                  const SizedBox(height: 5),
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
              loading: () => const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          ])),
    );
  }
}
