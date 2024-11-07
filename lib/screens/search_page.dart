import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:marquee/marquee.dart';

import 'package:provider/provider.dart';

import 'package:vynt/controllers/scroll_monitor.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        controller: scrollMonitor.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                backgroundColor: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
                placeholder: 'Search',
                placeholderStyle: const TextStyle(color: Colors.grey),
                itemColor: Colors.grey,
                style: const TextStyle(color: Colors.white),
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
                    color: Colors.grey[800],
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
              style: const TextStyle(color: Colors.white, fontSize: 11),
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
              style: const TextStyle(color: Colors.grey, fontSize: 9),
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
