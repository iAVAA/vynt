import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vynt/screens/nav_bar_pages/feed_page.dart';
import 'package:vynt/screens/nav_bar_pages/library_page.dart';
import 'package:vynt/screens/nav_bar_pages/discover_page.dart';
import 'package:vynt/screens/nav_bar_pages/profile_page.dart';
import 'package:vynt/widgets/nav_bar_widgets/navigation_bar.dart';
import 'package:vynt/widgets/nav_bar_pages_widgets/add_post_widget.dart';
import 'package:vynt/controllers/scroll_monitor.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Feed(),
    Discover(),
    SizedBox.shrink(), // Placeholder for "add post" (handled via modal)
    LibraryPage(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showAddPostWidget();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showAddPostWidget() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const AddPostWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use the global ScrollMonitor from the provider, not a local instance
    final scrollMonitor = Provider.of<ScrollMonitor>(context, listen: false);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        pages: _pages,
        scrollMonitor: scrollMonitor,
      ),
    );
  }
}