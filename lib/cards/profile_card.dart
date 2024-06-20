import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/services/user_api.dart';

class ProfileCard extends ConsumerStatefulWidget {
  const ProfileCard({super.key, required this.user});

  final User user;

  @override
  ConsumerState<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends ConsumerState<ProfileCard> {
  late bool _isFollowing;
  late int _numFollowers;

  bool _isLoading = false;

  void _followUser() async {
    setState(() {
      _isLoading = true;
    });
    await followUser(widget.user.id);
    ref.invalidate(fetchUserProvider);
    setState(() {
      _numFollowers += 1;
      _isFollowing = !_isFollowing;
      _isLoading = false;
    });
  }

  void _unfollowUser() async {
    setState(() {
      _isLoading = true;
    });
    await unfollowUser(widget.user.id);
    ref.invalidate(fetchUserProvider);
    setState(() {
      _numFollowers -= 1;
      _isFollowing = !_isFollowing;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.followedBy.contains(ref.read(userProvider)!.id);
    _numFollowers = widget.user.numFollowers;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      'http://10.0.2.2:8080/img/users/${widget.user.photo}'),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.username,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text('followers'),
                            Text(
                              _numFollowers.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Column(
                          children: [
                            const Text('following'),
                            Text(
                              widget.user.numFollowing.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 30,
                      width: 200,
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        color: _isFollowing
                            ? CupertinoColors
                                .systemRed.highContrastElevatedColor
                            : CupertinoColors.activeBlue,
                        onPressed: _isLoading
                            ? null
                            : _isFollowing
                                ? _unfollowUser
                                : _followUser,
                        child: Text(
                          _isFollowing ? 'Unfollow' : 'Follow',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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
