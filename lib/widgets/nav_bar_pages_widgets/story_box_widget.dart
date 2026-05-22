import 'package:flutter/material.dart';

class StoryBoxRow extends StatelessWidget {
  const StoryBoxRow({super.key});

  // Sample usernames for stories
  static const List<String> _usernames = [
    'alex_music',
    'vinyl_lover',
    'beatmaker',
    'j_tunes',
    'melodia',
    'soundwave',
    'basso99',
    'klara.m',
    'dj_marco',
    'lunar_bpm',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _usernames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: StoryBox(username: _usernames[index], seen: index > 2),
          );
        },
      ),
    );
  }
}

class StoryBox extends StatefulWidget {
  final String username;
  final bool seen;

  const StoryBox({required this.username, this.seen = false, super.key});

  @override
  _StoryBoxState createState() => _StoryBoxState();
}

class _StoryBoxState extends State<StoryBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar with gradient ring
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.seen
                  ? LinearGradient(
                      colors: [
                        Colors.grey.withValues(alpha: 0.4),
                        Colors.grey.withValues(alpha: 0.4),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        colorScheme.tertiary,
                        colorScheme.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            padding: const EdgeInsets.all(2.5),
            child: Stack(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/test_pictures/test_post.webp',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                // Spinning vinyl badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: RotationTransition(
                    turns: _rotationController,
                    child: Image.asset(
                      'assets/arts/vinyl_status.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          // Username
          SizedBox(
            width: 64,
            child: Text(
              widget.username,
              style: TextStyle(
                color: widget.seen
                    ? Theme.of(context).textTheme.bodySmall?.color
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 10,
                fontWeight:
                    widget.seen ? FontWeight.normal : FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}