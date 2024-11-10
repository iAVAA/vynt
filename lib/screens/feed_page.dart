import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vynt/screens/subscreens/message_page.dart';
import 'package:vynt/widgets/application_bar.dart';
import 'package:vynt/controllers/scroll_monitor.dart';
import 'package:vynt/widgets/post_widget.dart';
import 'package:vynt/widgets/story_box_widget.dart';

import 'package:vynt/constants.dart' as constants;

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildBody(context, scrollMonitor),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }

  Widget _buildBody(BuildContext context, ScrollMonitor scrollMonitor) {
    final PageController pageController = PageController(initialPage: 1);

    return PageView(
      controller: pageController,
      physics: const ClampingScrollPhysics(),
      children: [
        const Placeholder(),
        _buildFeedContent(context, pageController, scrollMonitor),
        const MessagePage(),
      ],
    );
  }

  Widget _buildFeedContent(BuildContext context, PageController pageController,
      ScrollMonitor scrollMonitor) {
    return CustomScrollView(
      controller: scrollMonitor.scrollController,
      slivers: [
        ApplicationBar(
          title: constants.appName,
          scrollController: scrollMonitor.scrollController,
          pageController: pageController,
        ),
        const SliverToBoxAdapter(child: StoryBoxRow()),
        const SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const PostWidget(index: 10);
            },
            childCount: 10,
          ),
        ),
      ],
    );
  }
}
