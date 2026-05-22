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
    return Stack(
      children: [
        // Page content
        pages[selectedIndex],
        // Navigation bar — only rebuild the animated position, not the whole stack
        _AnimatedNavBar(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped,
        ),
      ],
    );
  }
}

/// Separated widget so only it rebuilds when ScrollMonitor changes
class _AnimatedNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const _AnimatedNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ScrollMonitor, bool>(
      selector: (_, monitor) => monitor.isScrollingDown,
      builder: (context, isScrollingDown, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          left: 0,
          right: 0,
          bottom: isScrollingDown
              ? -MediaQuery.of(context).size.height * 0.15
              : 0,
          child: child!,
        );
      },
      child: CrystalNavigationBar(
        currentIndex: selectedIndex,
        unselectedItemColor: Theme.of(context).textTheme.bodyLarge?.color,
        splashColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6),
        onTap: onItemTapped,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        items: [
          CrystalNavigationBarItem(
            icon: CupertinoIcons.house_fill,
            unselectedIcon: CupertinoIcons.house,
            selectedColor: Theme.of(context).colorScheme.tertiary,
          ),
          CrystalNavigationBarItem(
            icon: CupertinoIcons.search,
            unselectedIcon: CupertinoIcons.search,
            selectedColor: Theme.of(context).colorScheme.tertiary,
          ),
          CrystalNavigationBarItem(
            icon: CupertinoIcons.add_circled_solid,
            unselectedIcon: CupertinoIcons.add_circled,
            selectedColor: Theme.of(context).colorScheme.tertiary,
          ),
          CrystalNavigationBarItem(
            icon: CupertinoIcons.music_albums_fill,
            unselectedIcon: CupertinoIcons.music_albums,
            selectedColor: Theme.of(context).colorScheme.tertiary,
          ),
          CrystalNavigationBarItem(
            icon: CupertinoIcons.person_fill,
            unselectedIcon: CupertinoIcons.person,
            selectedColor: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
