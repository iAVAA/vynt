import 'package:flutter/material.dart';

class StoryBoxRow extends StatelessWidget {
  const StoryBoxRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          10,
          (index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: StoryBox(),
          ),
        ),
      ),
    );
  }
}

class StoryBox extends StatefulWidget {
  const StoryBox({super.key});

  @override
  _StoryBoxState createState() => _StoryBoxState();
}

class _StoryBoxState extends State<StoryBox> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/test_pictures/test_post.webp'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: RotationTransition(
              turns: _rotationController,
              child: const CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage('assets/arts/vinyl_status.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}