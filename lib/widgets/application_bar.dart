import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicationBar extends StatelessWidget {
  final String title;
  final ScrollController scrollController;
  final PageController pageController; // Add PageController

  const ApplicationBar({
    super.key,
    required this.title,
    required this.scrollController,
    required this.pageController, // Add PageController
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      pinned: true,
      forceMaterialTransparency: true,
      elevation: 0,
      expandedHeight: 80,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double expandedHeight = 80.0;
          double collapsedHeight = kToolbarHeight;
          double t = ((constraints.maxHeight - collapsedHeight) /
                  (expandedHeight - collapsedHeight))
              .clamp(0.0, 1.0);
          double iconSize = 20 + (4 * t);

          return FlexibleSpaceBar(
            titlePadding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.headphones,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: () {},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20 + (5 * t),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.paperplane,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                )
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