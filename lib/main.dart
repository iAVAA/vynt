import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vynt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Feed(title: 'Vynt'),
    );
  }
}

class Feed extends StatefulWidget {
  const Feed({super.key, required this.title});
  final String title;

  @override
  State<Feed> createState() => _FeedState();
}

enum _SelectedTab { home, search, add, library, profile }

class _FeedState extends State<Feed> {
  _SelectedTab _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _buildBody(),
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(
                title: Text('Item #$index', style: const TextStyle(color: Colors.white)),
                tileColor: index % 2 == 0 ? Colors.blueAccent : Colors.lightBlue,
              );
            },
            childCount: 20, // Number of list items
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      pinned: true,
      elevation: 0,
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 20),
      ),
      leading: IconButton(
        icon: const Icon(Icons.square, color: Colors.white),
        onPressed: () {
          // Action for the left icon
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.square, color: Colors.white),
          onPressed: () {
            // Action for the right icon
          },
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CrystalNavigationBar(
      enableFloatingNavBar: true,
      enablePaddingAnimation: true,
      currentIndex: _SelectedTab.values.indexOf(_selectedTab),
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.black.withOpacity(0.1),
      splashColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      onTap: _handleIndexChanged,
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
