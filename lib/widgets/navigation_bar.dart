import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<Widget> pages;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        pages[selectedIndex],
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CrystalNavigationBar(
            enableFloatingNavBar: true,
            enablePaddingAnimation: true,
            currentIndex: selectedIndex,
            unselectedItemColor: Colors.white70,
            backgroundColor: Colors.black.withOpacity(0.1),
            splashColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            onTap: onItemTapped,
            items: [
              CrystalNavigationBarItem(
                icon: CupertinoIcons.house_fill,
                unselectedIcon: CupertinoIcons.house,
                selectedColor: Colors.black,
                unselectedColor: Colors.grey,
              ),
              CrystalNavigationBarItem(
                icon: CupertinoIcons.search,
                unselectedIcon: CupertinoIcons.search,
                selectedColor: Colors.black,
                unselectedColor: Colors.grey,
              ),
              CrystalNavigationBarItem(
                icon: CupertinoIcons.add,
                unselectedIcon: CupertinoIcons.add,
                selectedColor: Colors.black,
                unselectedColor: Colors.grey,
              ),
              CrystalNavigationBarItem(
                icon: CupertinoIcons.music_albums_fill,
                unselectedIcon: CupertinoIcons.music_albums,
                selectedColor: Colors.black,
                unselectedColor: Colors.grey,
              ),
              CrystalNavigationBarItem(
                icon: CupertinoIcons.person_fill,
                unselectedIcon: CupertinoIcons.person,
                selectedColor: Colors.black,
                unselectedColor: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
