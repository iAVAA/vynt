import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vynt/screens/subscreens/message_page.dart';

import '/constants.dart' as constants;
import '/widgets/application_bar.dart';
import '/controllers/scroll_monitor.dart';
import '/widgets/post_widget.dart';
import '/widgets/story_box_widget.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScrollMonitor(),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            _buildBody(context),
          ],
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final PageController pageController = PageController(initialPage: 1);

    return PageView(
      controller: pageController,
      physics: const ClampingScrollPhysics(),
      children: [
        const Placeholder(),
        _buildFeedContent(context),
        const MessagePage(),
      ],
    );
  }

  Widget _buildFeedContent(BuildContext context) {
    return Consumer<ScrollMonitor>(
      builder: (context, scrollMonitor, child) {
        return CustomScrollView(
          controller: scrollMonitor.scrollController,
          slivers: [
            ApplicationBar(
              title: constants.appName,
              scrollController: scrollMonitor.scrollController,
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
      },
    );
  }
}
