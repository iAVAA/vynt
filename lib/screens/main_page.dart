import 'package:flutter/material.dart';
import 'feed_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/add_post_widget.dart';

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
    AddPostWidget(),
    Placeholder(),
    Profile(),
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
        pages: _pages,
      ),
    );
  }
}
