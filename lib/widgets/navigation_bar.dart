import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:vynt/controllers/scroll_monitor.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<Widget> pages;
  final ScrollMonitor scrollMonitor;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.pages,
    required this.scrollMonitor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Positioned.fill(
            child: pages[selectedIndex],
          ),
          Consumer<ScrollMonitor>(
            builder: (context, scrollMonitor, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                left: 0,
                right: 0,
                bottom: scrollMonitor.navBarOffset,
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
              );
            },
          ),
        ],
      ),
    );
  }
}