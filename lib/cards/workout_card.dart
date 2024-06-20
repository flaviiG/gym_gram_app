import 'package:flutter/material.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/screens/workout_details_screen.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard(
      {super.key, required this.workout, required this.isSelectable});

  final Workout workout;
  final bool isSelectable;

  @override
  Widget build(BuildContext context) {
    final int numExercises = workout.exercises.length;
    final int numSets =
        workout.exercises.fold(0, (acc, curr) => acc + curr.sets.length);

    return IgnorePointer(
      ignoring: isSelectable,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => !isSelectable
            ? Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => WorkoutDetailsScreen(workout: workout)))
            : {},
        onLongPress: () => isSelectable
            ? Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => WorkoutDetailsScreen(workout: workout)))
            : {},
        child: Card(
          color: const Color.fromARGB(255, 140, 20, 20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(workout.date.toString().split(' ')[0])
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        numExercises.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        numExercises == 1 ? 'exercise' : 'exercises',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        numSets.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(numSets == 1 ? 'set' : 'sets'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
