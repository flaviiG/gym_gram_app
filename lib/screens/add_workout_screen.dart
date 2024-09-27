import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/exercise.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/providers/exercises_provider.dart';
import 'package:gym_gram_app/providers/workouts_provider.dart';
import 'package:gym_gram_app/services/workout_api.dart';
import 'package:search_choices/search_choices.dart';

const muscleGroups = [
  'Back',
  'Chest',
  'Biceps',
  'Triceps',
  'Shoulders',
  'Quads',
  'Hamstrings',
  'Calves',
  'Abs',
  'Forearms',
  'Trapezius',
  'Lats',
  'Glutes',
  'Cardio',
  'Unknown',
  'All',
];

class AddWorkoutScreen extends ConsumerStatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  ConsumerState<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends ConsumerState<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();

  String _workoutName = '';

  final List<String> _selectedMuscleGroup = [];
  final List<Exercise?> _selectedExercises = [];
  final List<List<Set>> _enteredSets = [];

  bool _isSending = false;

  String? _error;

  void _addExercise() {
    setState(() {
      _selectedMuscleGroup.add('All');
      _selectedExercises.add(null);
      _enteredSets.add([]);
    });
  }

  void _onDeleteSet(int exerciseIndex, int setIndex) {
    setState(() {
      _enteredSets[exerciseIndex].removeAt(setIndex);
    });
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      _enteredSets[exerciseIndex].add(Set(reps: 0, weight: 0));
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _selectedExercises.removeAt(index);
    });
  }

  void _submitForm() async {
    if (_selectedExercises.isEmpty) {
      setState(() {
        _error = 'You must add some exercises to your workout';
      });
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      Map<String, List<Set>> workoutExercises = {};

      for (int i = 0; i < _selectedExercises.length; i++) {
        workoutExercises.addAll({_selectedExercises[i]!.id: _enteredSets[i]});
      }

      await createWorkout(_workoutName, workoutExercises);

      // ref.invalidate(workoutsProvider);

      ref.invalidate(workoutsProvider);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop();
    }
  }

  dynamic searchExercise(String keyword, items) {
    List<int> ret = [];
    if (items != null && keyword.isNotEmpty) {
      keyword.split(" ").forEach((k) {
        int i = 0;
        items.forEach((item) {
          if (k.isNotEmpty &&
              (item.value.name
                  .toString()
                  .toLowerCase()
                  .contains(k.toLowerCase()))) {
            ret.add(i);
          }
          i++;
        });
      });
    }
    if (keyword.isEmpty) {
      ret = Iterable<int>.generate(items.length).toList();
    }
    return (ret);
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exerciseProvider);
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: _submitForm,
                child: _isSending
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.activeBlue,
                      )
                    : Text(
                        'Add',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ))
          ],
        ),
        body: exercisesAsync.when(
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const CircularProgressIndicator(),
          data: (exercises) => SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'Create your workout',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35),
                ),
                const SizedBox(height: 20),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CupertinoTextFormFieldRow(
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLength: 50,
                          prefix: const Text('Give your workout a name'),
                          placeholder: 'my workout name',
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 1 ||
                                value.trim().length > 50) {
                              return 'Must be between 1 and 50 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _workoutName = value!;
                          },
                        ),
                        if (_error != null)
                          Text(
                            _error!,
                            style: const TextStyle(
                                color: CupertinoColors.systemRed,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(height: 20),
                        for (int i = 0; i < _selectedExercises.length; i++)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SearchChoices.single(
                                          autofocus: false,
                                          displayClearIcon: false,
                                          isExpanded: true,
                                          value: _selectedMuscleGroup[i],
                                          label: 'Muscle Group',
                                          items: muscleGroups.map((group) {
                                            return DropdownMenuItem<String>(
                                              value: group,
                                              child: Text(group),
                                            );
                                          }).toList(),
                                          searchHint: "Select the muscle group",
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedMuscleGroup[i] = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: SearchChoices.single(
                                        autofocus: false,
                                        displayClearIcon: false,
                                        items: exercises
                                            .where((exercise) =>
                                                _selectedMuscleGroup[i] == 'All'
                                                    ? true
                                                    : exercise.muscleGroup ==
                                                        _selectedMuscleGroup[i])
                                            .map((exercise) {
                                          return DropdownMenuItem<Exercise>(
                                            value: exercise,
                                            child: Text(exercise.name),
                                          );
                                        }).toList(),
                                        searchFn: searchExercise,
                                        value: _selectedExercises[i],
                                        hint: "Select exercise",
                                        label: 'Exercise',
                                        searchHint: "Select exercise",
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedExercises[i] = value;
                                          });
                                        },
                                        isExpanded: true,
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select an exercise';
                                          }
                                          return null;
                                        },
                                      )),
                                    ],
                                  ),
                                  for (int j = 0;
                                      j < _enteredSets[i].length;
                                      j++)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CupertinoTextFormFieldRow(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            maxLength: 50,
                                            prefix: const Text('Reps'),
                                            placeholder: '12',
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter reps';
                                              }
                                              if (int.tryParse(value) == null) {
                                                return 'Enter a valid number of reps';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _enteredSets[i][j].reps =
                                                  int.parse(value!);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                            child: CupertinoTextFormFieldRow(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          maxLength: 50,
                                          prefix: const Text('Weight'),
                                          placeholder: '3',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter weight';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _enteredSets[i][j].weight =
                                                double.parse(value!);
                                          },
                                        )),
                                        IconButton(
                                            onPressed: () {
                                              _onDeleteSet(i, j);
                                            },
                                            icon: const Icon(CupertinoIcons
                                                .xmark_circle_fill))
                                      ],
                                    ),
                                  IconButton(
                                    onPressed: () {
                                      _addSet(i);
                                    },
                                    icon: const Icon(
                                        CupertinoIcons.add_circled_solid),
                                  )
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        TextButton(
                            onPressed: () {
                              _addExercise();
                            },
                            child: Text(
                              'Add exercise',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ))
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
