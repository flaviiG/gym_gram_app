import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/services/user_api.dart';
import 'package:gym_gram_app/utils/globals.dart';
import 'package:gym_gram_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileCard extends ConsumerStatefulWidget {
  const MyProfileCard({super.key});

  @override
  ConsumerState<MyProfileCard> createState() => _MyProfileCardState();
}

class _MyProfileCardState extends ConsumerState<MyProfileCard> {
  //
  //

  void _selectImage(String url) async {
    XFile? image = await pickImage(ImageSource.gallery, "1/1");
    if (image != null) {
      bool success = await changeProfilePic(image);
      if (success) {
        ref.invalidate(fetchUserProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('Building myprofile card');
    User user = ref.watch(userProvider)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          '$kBaseStorageUrl/users/${user.photo}'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _selectImage('$kBaseStorageUrl/users/${user.photo}');
                    },
                    icon: const Icon(
                      size: 30,
                      Icons.change_circle_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // const SizedBox(width: 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              user.numFollowers.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const Text('followers'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              user.numFollowing.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const Text('following'),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
