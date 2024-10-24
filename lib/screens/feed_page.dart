import 'package:flutter/material.dart';
import '/widgets/navbar.dart';
import '/widgets/appbar.dart';

class Feed extends StatefulWidget {
  const Feed({super.key, required this.title});
  final String title;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  SelectedTab _selectedTab = SelectedTab.home;

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = SelectedTab.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _buildBody(),
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: BlurredNavigationBar(
        selectedTab: _selectedTab,
        onIndexChanged: _handleIndexChanged,
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        ApplicationBar(title: widget.title),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(
                title: Text('Item #$index', style: const TextStyle(color: Colors.white)),
                tileColor: index % 2 == 0 ? Colors.blueAccent : Colors.lightBlue,
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}