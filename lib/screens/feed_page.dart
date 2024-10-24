import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/navigation_bar.dart';
import '/widgets/application_bar.dart';
import '/controllers/scroll_monitor.dart';

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
    return ChangeNotifierProvider(
      create: (_) => ScrollMonitor(),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            _buildBody(),
            Consumer<ScrollMonitor>(
              builder: (context, scrollMonitor, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: scrollMonitor.isNavBarVisible ? 0 : -130,
                  left: 0,
                  right: 0,
                  child: BlurredNavigationBar(
                    selectedTab: _selectedTab,
                    onIndexChanged: _handleIndexChanged,
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<ScrollMonitor>(
      builder: (context, scrollMonitor, child) {
        return CustomScrollView(
          controller: scrollMonitor.scrollController,
          slivers: [
            ApplicationBar(title: widget.title),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ListTile(
                      title: Text('Item #$index', style: const TextStyle(color: Colors.white)),
                      tileColor: index % 2 == 0 ? Colors.blueAccent : Colors.lightBlue
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        );
      },
    );
  }
}