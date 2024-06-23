import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/workout_card.dart';
import 'package:gym_gram_app/models/workout.dart';
import 'package:gym_gram_app/providers/my_posts_provider.dart';
import 'package:gym_gram_app/screens/select_workout_screen.dart';
import 'package:gym_gram_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  //
  //
  int _index = 0;
  Workout? _selectedWorkout;
  XFile? _selectedPhoto;
  final descriptionController = TextEditingController();

  void _selectPhoto() async {
    XFile? image = await pickImage(ImageSource.gallery, "4/5");
    if (image != null) {
      setState(() {
        _selectedPhoto = image;
      });
    }
  }

  void _selectWorkout() async {
    Workout? selectedWorkout = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const SelectWorkoutScreen()));
    if (selectedWorkout != null) {
      setState(() {
        _selectedWorkout = selectedWorkout;
      });
    }
  }

  void _post() async {
    if (_selectedPhoto != null &&
        _selectedWorkout != null &&
        descriptionController.text.isNotEmpty) {
      await ref.read(myPostsProvider.notifier).createPost(
          _selectedWorkout!.id, _selectedPhoto!, descriptionController.text);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post created!')));

      setState(() {
        _selectedPhoto = null;
        _selectedWorkout = null;
        descriptionController.text = '';
        _index = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New post'),
        actions: [
          IconButton(
              onPressed: _post,
              icon: const Icon(FluentIcons.checkbox_checked_20_regular))
        ],
      ),
      body: Stepper(
        connectorThickness: 0,
        currentStep: _index,
        onStepCancel: () {
          switch (_index) {
            case 0:
              setState(() {
                _selectedPhoto = null;
              });
              break;
            case 1:
              setState(() {
                _selectedWorkout = null;
              });
            case 2:
              setState(() {
                descriptionController.text = '';
              });
          }
        },
        onStepContinue: _index <= 1
            ? () => {
                  setState(() {
                    _index += 1;
                  })
                }
            : null,
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        steps: <Step>[
          Step(
            title: const Text('Add photo'),
            content: AspectRatio(
              aspectRatio: 4 / 5,
              child: _selectedPhoto != null
                  ? Image.file(File(_selectedPhoto!.path))
                  : Center(
                      child: IconButton(
                          onPressed: _selectPhoto,
                          icon: const Icon(
                            FluentIcons.image_add_24_regular,
                            size: 50,
                          )),
                    ),
            ),
          ),
          Step(
            title: const Text('Select workout'),
            content: _selectedWorkout != null
                ? WorkoutCard(workout: _selectedWorkout!, isSelectable: false)
                : IconButton(
                    onPressed: _selectWorkout,
                    icon: const Icon(FluentIcons.list_16_regular),
                  ),
          ),
          Step(
            title: const Text('Description'),
            content: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Your description...',
                  hintStyle: TextStyle(fontStyle: FontStyle.italic)),
            ),
          )
        ],
      ),
    );
  }
}
