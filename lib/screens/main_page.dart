import 'package:flutter/material.dart';
import 'feed_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import '../widgets/navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Feed(),
    Search(),
    Placeholder(),
    Placeholder(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        pages: _pages,
      ),
    );
  }
}
