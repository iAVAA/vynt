import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:vynt/controllers/scroll_monitor.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        controller: scrollMonitor.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[700],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[500],
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'User Name',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Text(
                    'Post $index',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Description of post $index',
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}