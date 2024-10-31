import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/constants.dart' as constants;
import '/widgets/application_bar.dart';
import '/controllers/scroll_monitor.dart';
import '/widgets/post_widget.dart';
import '/widgets/story-box_widget.dart';

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
    return Consumer<ScrollMonitor>(
      builder: (context, scrollMonitor, child) {
        return CustomScrollView(
          controller: scrollMonitor.scrollController,
          slivers: [
            const ApplicationBar(title: constants.appName),
            const SliverToBoxAdapter(child: StoryBoxRow()),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostWidget(index: index);
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