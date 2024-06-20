import 'package:gym_gram_app/models/exercise.dart';

class Workout {
  //

  Workout(
      {required this.id,
      required this.userId,
      required this.name,
      required this.exercises,
      required this.date,
      this.numSaves});

  final String id;
  final String userId;
  final String name;
  final List<ExerciseWorkout> exercises;
  final DateTime date;
  final int? numSaves;

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      exercises: (json['exercises'] as List)
          .map((exerciseJson) => ExerciseWorkout.fromJson(exerciseJson))
          .toList(),
      date: DateTime.parse(json['date'] as String),
      numSaves: json['numSaves'] as int?,
    );
  }
}

class ExerciseWorkout {
  //

  ExerciseWorkout({required this.exercise, required this.sets});

  final Exercise exercise;
  final List<Set> sets;

  factory ExerciseWorkout.fromJson(Map<String, dynamic> json) {
    return ExerciseWorkout(
      exercise: Exercise.fromJson(json['exercise']),
      sets: (json['sets'] as List)
          .map((setJson) => Set.fromJson(setJson))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.toJson(),
      'sets': sets.map((s) => s.toJson()).toList(),
    };
  }
}

class Set {
  //

  Set({required this.reps, required this.weight});

  int reps;
  double weight;

  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      reps: json['reps'] as int,
      weight: (json['weight'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }
}
