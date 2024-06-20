import 'package:accordion/accordion.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/providers/workouts_provider.dart';

class WorkoutDetailsScreen extends ConsumerStatefulWidget {
  const WorkoutDetailsScreen({super.key, required this.workout});

  final Workout workout;

  @override
  ConsumerState<WorkoutDetailsScreen> createState() =>
      _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends ConsumerState<WorkoutDetailsScreen> {
  //
  late bool _isSaved;

  @override
  void initState() {
    _isSaved =
        ref.read(userProvider)!.savedWorkouts.contains(widget.workout.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.workout.name),
          actions: user.id == widget.workout.userId
              ? [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(FluentIcons.delete_12_regular))
                ]
              : [
                  IconButton(
                      onPressed: () {
                        if (_isSaved) {
                          ref
                              .read(userProvider.notifier)
                              .removeSavedWorkout(widget.workout.id);
                        } else {
                          ref
                              .read(userProvider.notifier)
                              .saveWorkout(widget.workout.id);
                        }
                        ref.invalidate(savedWorkoutsProvider);
                        setState(() {
                          _isSaved = !_isSaved;
                        });
                      },
                      icon: _isSaved
                          ? const Icon(CupertinoIcons.bookmark_fill)
                          : const Icon(CupertinoIcons.bookmark))
                ],
        ),
        body: Accordion(
          children: [
            ...widget.workout.exercises.map((e) {
              final exercise = e.exercise;
              return AccordionSection(
                headerPadding: const EdgeInsets.all(10),
                contentBorderWidth: 0,
                headerBorderWidth: 0,
                headerBackgroundColor: const Color.fromARGB(255, 20, 140, 140),
                contentBackgroundColor: Colors.black,
                header: Column(children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Muscle group: ${exercise.muscleGroup}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Created by ${exercise.createdBy}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ]),
                content: Column(
                  children: e.sets
                      .map((s) => SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${s.reps} reps'),
                                  const SizedBox(width: 20),
                                  Text('${s.weight} kg')
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              );
            })
          ],
        ));
  }
}
