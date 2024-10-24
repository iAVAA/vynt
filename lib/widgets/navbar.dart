import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

enum SelectedTab { home, search, add, library, profile }

class CustomNavigationBar extends StatelessWidget {
  final SelectedTab selectedTab;
  final ValueChanged<int> onIndexChanged;

  const CustomNavigationBar({
    Key? key,
    required this.selectedTab,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CrystalNavigationBar(
      enableFloatingNavBar: true,
      enablePaddingAnimation: true,
      currentIndex: SelectedTab.values.indexOf(selectedTab),
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.black.withOpacity(0.1),
      splashColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      onTap: onIndexChanged,
      items: _buildNavigationBarItems(),
    );
  }

  List<CrystalNavigationBarItem> _buildNavigationBarItems() {
    return [
      _buildNavigationBarItem(Icons.square, Colors.white),
      _buildNavigationBarItem(Icons.square, Colors.white),
      _buildNavigationBarItem(Icons.square, Colors.white),
      _buildNavigationBarItem(Icons.square, Colors.yellow),
      _buildNavigationBarItem(Icons.square, Colors.white),
    ];
  }

  CrystalNavigationBarItem _buildNavigationBarItem(IconData icon, Color selectedColor) {
    return CrystalNavigationBarItem(
      icon: icon,
      unselectedIcon: icon,
      selectedColor: selectedColor,
    );
  }
}