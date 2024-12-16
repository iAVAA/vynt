import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';

class ApplicationBar extends StatelessWidget {
  final String title;
  final ScrollController scrollController;
  final PageController pageController;

  const ApplicationBar({
    super.key,
    required this.title,
    required this.scrollController,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      pinned: true,
      forceMaterialTransparency: true,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding:
            const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.headphones,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
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
                  fontSize: 25,
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
                  size: 25,
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
        collapseMode: CollapseMode.parallax,
      ),
    );
  }
}
