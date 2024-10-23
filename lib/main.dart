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
      home: const MyHomePage(title: 'Vynt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum _SelectedTab { home, search, add, library, profile }

class _MyHomePageState extends State<MyHomePage> {
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text(
          'Prova',
        ),
      ),
      backgroundColor: Colors.blueAccent,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: CrystalNavigationBar(
          enableFloatingNavBar: true,
          enablePaddingAnimation: true,
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.1),
          splashColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          onTap: _handleIndexChanged,
          items: [
            // Home
            CrystalNavigationBarItem(
              icon: Icons.square,
              unselectedIcon: Icons.square,
              selectedColor: Colors.white,
            ),
            // Search
            CrystalNavigationBarItem(
              icon: Icons.square,
              unselectedIcon: Icons.square,
              selectedColor: Colors.white,
            ),
            // Add
            CrystalNavigationBarItem(
              icon: Icons.square,
              unselectedIcon: Icons.square,
              selectedColor: Colors.white,
            ),
            // Library
            CrystalNavigationBarItem(
              icon: Icons.square,
              unselectedIcon: Icons.square,
              selectedColor: Colors.yellow,
            ),
            // Profile
            CrystalNavigationBarItem(
              icon: Icons.square,
              unselectedIcon: Icons.square,
              selectedColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}