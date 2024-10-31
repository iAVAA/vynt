import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class StoryBoxRow extends StatelessWidget {
  const StoryBoxRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5,
          (index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: StoryBox(),
          ),
        ),
      ),
    );
  }
}

class StoryBox extends StatelessWidget {
  const StoryBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/test_pictures/daniele_pfp.png'),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            height: 20,
            child: Marquee(
              text: 'Song Name - Album Name',
              style: const TextStyle(color: Colors.white, fontSize: 14),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 30.0,
              startPadding: 10.0,
              pauseAfterRound: const Duration(seconds: 1),
            ),
          ),
          SizedBox(
            width: 80,
            height: 20,
            child: Marquee(
              text: 'Artist Name',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
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