import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vynt/screens/subscreens/listening_party_page.dart';

import 'package:vynt/screens/subscreens/message_page.dart';
import 'package:vynt/widgets/nav_bar_widgets/application_bar.dart';
import 'package:vynt/controllers/scroll_monitor.dart';
import 'package:vynt/widgets/nav_bar_pages_widgets/post_widget.dart';
import 'package:vynt/widgets/nav_bar_pages_widgets/story_box_widget.dart';

import 'package:vynt/constants/constants.dart' as constants;

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);
    final PageController pageController = PageController(initialPage: 1);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildBody(context, pageController, scrollMonitor),
        ],
      ),
      backgroundColor: constants.bgColor,
    );
  }

  Widget _buildBody(BuildContext context, PageController pageController, ScrollMonitor scrollMonitor) {
    return PageView(
      controller: pageController,
      physics: const ClampingScrollPhysics(),
      children: [
        const ListeningPartyPage(),
        _buildFeedContent(context, pageController, scrollMonitor),
        MessagePage(pageController: pageController),
      ],
    );
  }

  Widget _buildFeedContent(BuildContext context, PageController pageController, ScrollMonitor scrollMonitor) {
    return CustomScrollView(
      key: const PageStorageKey('feed'),
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
              return RepaintBoundary(
                child: PostWidget(index: index + 1),
              );
            },
            childCount: 5,
          ),
        ),
      ],
    );
  }
}