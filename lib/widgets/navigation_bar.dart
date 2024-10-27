import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../screens/search_page.dart';
import '../screens/feed_page.dart';

enum SelectedTab { home, search, add, library, profile }

class BlurredNavigationBar extends StatelessWidget {
  final SelectedTab selectedTab;
  final ValueChanged<int> onIndexChanged;

  const BlurredNavigationBar({
    super.key,
    required this.selectedTab,
    required this.onIndexChanged,
  });

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
      onTap: (index) {
        if (SelectedTab.values[index] != selectedTab) {
          if (SelectedTab.values[index] == SelectedTab.search) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Search()),
            );
          } else if (SelectedTab.values[index] == SelectedTab.home) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Feed(title: 'Feed')),
            );
          }
          onIndexChanged(index);
        }
      },
      items: _buildNavigationBarItems(),
    );
  }

  List<CrystalNavigationBarItem> _buildNavigationBarItems() {
    return [
      _buildNavigationBarItem(Icons.home, Colors.grey),
      _buildNavigationBarItem(Icons.search, Colors.grey),
      _buildNavigationBarItem(Icons.add, Colors.grey),
      _buildNavigationBarItem(Icons.library_books, Colors.grey),
      _buildNavigationBarItem(Icons.person, Colors.grey),
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