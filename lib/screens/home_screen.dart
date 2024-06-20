import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_gram_app/screens/add_post_screen.dart';
import 'package:gym_gram_app/screens/feed_screen.dart';
import 'package:gym_gram_app/screens/my_profile_screen.dart';
import 'package:gym_gram_app/screens/search_screen.dart';
import 'package:gym_gram_app/screens/workouts_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building homeScreen');
    return Scaffold(
      body: IndexedStack(
        index: _selectedPageIndex,
        children: const [
          FeedScreen(),
          SearchSreen(),
          AddPostScreen(),
          WorkoutsScreen(),
          MyProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
        fixedColor: CupertinoColors.white,
        unselectedItemColor: CupertinoColors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
              icon: _selectedPageIndex == 0
                  ? const Icon(FluentIcons.home_12_filled)
                  : const Icon(FluentIcons.home_12_regular),
              label: 'Feed'),
          BottomNavigationBarItem(
              icon: _selectedPageIndex == 1
                  ? const Icon(FluentIcons.search_12_filled)
                  : const Icon(FluentIcons.search_12_regular),
              label: 'Search User'),
          BottomNavigationBarItem(
              icon: _selectedPageIndex == 2
                  ? const Icon(FluentIcons.add_12_filled)
                  : const Icon(FluentIcons.add_12_regular),
              label: 'New Post'),
          BottomNavigationBarItem(
              icon: _selectedPageIndex == 3
                  ? const Icon(FluentIcons.dumbbell_16_filled)
                  : const Icon(FluentIcons.dumbbell_16_regular),
              label: 'Workouts'),
          BottomNavigationBarItem(
              icon: _selectedPageIndex == 4
                  ? const Icon(CupertinoIcons.person_fill)
                  : const Icon(CupertinoIcons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}
