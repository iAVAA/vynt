import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
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
                icon: Icons.home,
                unselectedIcon: Icons.search,
                selectedColor: Colors.grey,
                unselectedColor: Colors.black,
              ),
              CrystalNavigationBarItem(
                icon: Icons.search,
                unselectedIcon: Icons.search,
                selectedColor: Colors.grey,
                unselectedColor: Colors.black,
              ),
              // Add other items here
            ],
          ),
        ),
      ],
    );
  }
}