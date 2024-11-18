import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:marquee/marquee.dart';

import 'package:provider/provider.dart';

import 'package:vynt/controllers/scroll_monitor.dart';
import 'package:vynt/constants/constants.dart' as constants;

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      backgroundColor: constants.bgColor,
      appBar: AppBar(
        backgroundColor: constants.bgColor,
        elevation: 0,
        title: Text(
          'Search',
          style: TextStyle(color: constants.primaryTextColor),
        ),
      ),
      body: CustomScrollView(
        key: const PageStorageKey('search'),
        controller: scrollMonitor.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                backgroundColor: constants.secondaryBgColor,
                borderRadius: BorderRadius.circular(10),
                placeholder: 'Search',
                placeholderStyle: TextStyle(color: constants.secondaryTextColor),
                itemColor: Colors.grey,
                style: TextStyle(color: constants.primaryTextColor),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                itemCount: 10,
                itemBuilder: (context, index) => _buildEventItem(),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: constants.secondaryBgColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[700],
                      size: 40,
                    ),
                  ),
                );
              },
              childCount: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[700],
            ),
            child: Icon(
              Icons.person,
              color: Colors.grey[500],
              size: 25,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            height: 18,
            child: Marquee(
              text: 'Event ${DateTime.now()}',
              style: TextStyle(color: constants.primaryTextColor, fontSize: 11),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 30.0,
              startPadding: 10.0,
              pauseAfterRound: const Duration(seconds: 1),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 70,
            height: 16,
            child: Marquee(
              text: 'Artist Name',
              style: TextStyle(color: constants.secondaryTextColor, fontSize: 9),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 30.0,
              startPadding: 10.0,
              pauseAfterRound: const Duration(seconds: 1),
            ),
          ),
        ],
      ),
    );
  }
}
