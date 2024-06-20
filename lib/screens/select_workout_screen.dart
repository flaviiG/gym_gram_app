import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/workout_card.dart';
import 'package:gym_gram_app/providers/workouts_provider.dart';
import 'package:gym_gram_app/screens/add_workout_screen.dart';

class SelectWorkoutScreen extends ConsumerWidget {
  const SelectWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final workoutsAsync = ref.watch(workoutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select workout'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (ctx) => const AddWorkoutScreen()));
              },
              icon: const Icon(CupertinoIcons.add_circled))
        ],
      ),
      body: workoutsAsync.when(
          data: (workouts) => ListView(
                children: [
                  ...workouts.map((w) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(context).pop(w),
                        child: WorkoutCard(
                          workout: w,
                          isSelectable: true,
                        ),
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
    );
  }
}
