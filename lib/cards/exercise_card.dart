import 'package:flutter/material.dart';
import 'package:gym_gram_app/models/workout.dart';

class ExerciseCard extends StatefulWidget {
  const ExerciseCard({super.key, required this.workoutExercise});

  final ExerciseWorkout workoutExercise;

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.workoutExercise.exercise;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Column(
                      children: [
                        Text(
                          exercise.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Muscle group ${exercise.muscleGroup}'),
                            Text('Created by ${exercise.createdBy}')
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: widget.workoutExercise.sets
                              .map((s) => Row(
                                    children: [
                                      Text('${s.reps} reps'),
                                      Text('${s.weight} kg')
                                    ],
                                  ))
                              .toList(),
                        )
                      ],
                    )
                  : Column(children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Muscle group ${exercise.muscleGroup}'),
                          Text('Created by ${exercise.createdBy}')
                        ],
                      ),
                    ])),
        ),
      ),
    );
  }
}
