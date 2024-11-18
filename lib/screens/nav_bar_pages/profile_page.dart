import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:vynt/controllers/scroll_monitor.dart';
import 'package:vynt/constants/constants.dart' as constants;

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      backgroundColor: constants.bgColor,
      appBar: AppBar(
        backgroundColor: constants.bgColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: constants.primaryTextColor),
        ),
      ),
      body: CustomScrollView(
        key: const PageStorageKey('profile'),
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
                  Text(
                    'User Name',
                    style: TextStyle(color: constants.primaryTextColor, fontSize: 24),
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
                    style: TextStyle(color: constants.primaryTextColor),
                  ),
                  subtitle: Text(
                    'Description of post $index',
                    style: TextStyle(color: constants.secondaryTextColor),
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
