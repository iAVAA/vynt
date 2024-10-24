import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool _isNavBarVisible = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isNavBarVisible) {
        setState(() {
          _isNavBarVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isNavBarVisible) {
        setState(() {
          _isNavBarVisible = true;
        });
      }
    }
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = SelectedTab.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildBody(),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isNavBarVisible ? 0 : -130,
            left: 0,
            right: 0,
            child: BlurredNavigationBar(
              selectedTab: _selectedTab,
              onIndexChanged: _handleIndexChanged,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      controller: _scrollController,
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