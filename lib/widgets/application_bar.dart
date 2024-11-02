import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/subscreens/message_page.dart';

class ApplicationBar extends StatelessWidget {
  final String title;
  final ScrollController scrollController;

  const ApplicationBar({
    super.key,
    required this.title,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      pinned: true,
      forceMaterialTransparency: true,
      elevation: 0,
      expandedHeight: 100,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double expandedHeight = 100.0;
          double collapsedHeight = kToolbarHeight;
          double t = ((constraints.maxHeight - collapsedHeight) /
                  (expandedHeight - collapsedHeight))
              .clamp(0.0, 1.0);
          double iconSize = 24 + (6 * t);

          return FlexibleSpaceBar(
            titlePadding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: iconSize,
                  ),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.messenger_outline_rounded,
                    color: Colors.white,
                    size: iconSize,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MessagePage()), // TODO OPEN IT SCROLLING LEFT TO RIGHT
                    );
                  },
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