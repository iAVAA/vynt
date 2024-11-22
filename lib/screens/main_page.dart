import 'package:flutter/material.dart';

import 'package:vynt/screens/nav_bar_pages/feed_page.dart';
import 'package:vynt/screens/nav_bar_pages/library_page.dart';
import 'package:vynt/screens/nav_bar_pages/search_page.dart';
import 'package:vynt/screens/nav_bar_pages/profile_page.dart';
import 'package:vynt/widgets/nav_bar_widgets/navigation_bar.dart';
import 'package:vynt/widgets/nav_bar_pages_widgets/add_post_widget.dart';
import 'package:vynt/screens/../controllers/scroll_monitor.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final ScrollMonitor _scrollMonitor = ScrollMonitor();

  static List<Widget> _pages(ScrollMonitor scrollMonitor) => <Widget>[
    const Feed(),
    const Search(),
    const AddPostWidget(),
    const LibraryPage(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showAddPostWidget(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showAddPostWidget(BuildContext context) {
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
    return Scaffold(
      body: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        pages: _pages(_scrollMonitor),
        scrollMonitor: _scrollMonitor,
      ),
    );
  }
}