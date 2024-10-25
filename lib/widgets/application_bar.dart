import 'package:flutter/material.dart';

class ApplicationBar extends StatelessWidget {
  final String title;

  const ApplicationBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      pinned: true,
      forceMaterialTransparency: true,
      elevation: 0,
      expandedHeight: 75,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double expandedHeight = 100.0;
          double collapsedHeight = kToolbarHeight;
          double t = ((constraints.maxHeight - collapsedHeight) / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);
          double iconSize = 19 + (6 * t);

          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only( left: 15.0, right: 15.0, bottom: 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: iconSize,
                  ),
                  onPressed: () {},
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.propane,
                    color: Colors.white,
                    size: iconSize,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
