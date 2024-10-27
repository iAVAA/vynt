import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/application_bar.dart';
import '/controllers/scroll_monitor.dart';

class Feed extends StatelessWidget {
  const Feed({super.key, required this.title});
  final String title;

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
            ApplicationBar(title: title),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
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