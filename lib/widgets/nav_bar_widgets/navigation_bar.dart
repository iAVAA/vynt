import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';

import 'package:vynt/controllers/scroll_monitor.dart';

import 'package:vynt/constants/constants.dart' as constants;

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
    return Stack(
      children: [
        pages[selectedIndex],
        Consumer<ScrollMonitor>(
          builder: (context, scrollMonitor, child) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              left: 0,
              right: 0,
              bottom: scrollMonitor.isScrollingDown
                  ? -MediaQuery.of(context).size.height * 0.15
                  : 0,
              child: CrystalNavigationBar(
                currentIndex: selectedIndex,
                unselectedItemColor: Theme.of(context).textTheme.bodyLarge?.color,
                splashColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                backgroundColor: Colors.grey.withValues(
                  alpha: 0.1
                ),
                onTap: onItemTapped,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                items: [
                  CrystalNavigationBarItem(
                    icon: CupertinoIcons.house_fill,
                    unselectedIcon: CupertinoIcons.house,
                    selectedColor: Colors.purple[600],
                  ),
                  CrystalNavigationBarItem(
                    icon: CupertinoIcons.search,
                    unselectedIcon: CupertinoIcons.search,
                    selectedColor: Colors.purple[600],
                  ),
                  CrystalNavigationBarItem(
                    icon: CupertinoIcons.add,
                    unselectedIcon: CupertinoIcons.add,
                    selectedColor: Colors.purple[600],
                  ),
                  CrystalNavigationBarItem(
                    icon: CupertinoIcons.music_albums_fill,
                    unselectedIcon: CupertinoIcons.music_albums,
                    selectedColor: Colors.purple[600],
                  ),
                  CrystalNavigationBarItem(
                    icon: CupertinoIcons.person_fill,
                    unselectedIcon: CupertinoIcons.person,
                    selectedColor: Colors.purple[600],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
