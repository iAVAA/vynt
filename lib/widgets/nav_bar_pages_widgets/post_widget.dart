import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vynt/controllers/animation_controller.dart';

class PostWidget extends StatelessWidget {
  final int index;

  const PostWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoRow(index: index),
          const SizedBox(height: 10),
          PostImage(
            index: index,
            onDoubleTapLike: () {
              print('Double tap liked post #$index');
            },
          ),
          const SizedBox(height: 10),
          const PostActions(),
          const SizedBox(height: 5),
          const Text(
            'Liked by user_x and others',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            'User $index: Sample caption for post #$index...',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'Posted on 01/01/2022',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final int index;

  const UserInfoRow({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/test_pictures/daniele_pfp.png'),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Text(
          'User $index',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
        )
      ],
    );
  }
}

class PostImage extends StatefulWidget {
  final int index;
  final VoidCallback onDoubleTapLike;

  const PostImage(
      {required this.index, required this.onDoubleTapLike, super.key});

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onInteractionEnd() {
    if (_transformationController.value != Matrix4.identity()) {
      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: Matrix4.identity(),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onDoubleTapLike,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            InteractiveViewer(
              transformationController: _transformationController,
              onInteractionEnd: (details) => _onInteractionEnd(),
              minScale: 1.0,
              maxScale: 4.0,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/test_pictures/test_post.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/arts/vinyl_art.png',
                            width: 200,
                            height: 270,
                          ),
                          Positioned(
                            bottom: 80,
                            right: 58,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/test_pictures/cover_art/${widget.index}.jpeg',
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/arts/cover_art.png',
                            width: 200,
                            height: 270,
                          ),
                          Positioned(
                            right: 72,
                            bottom: 50,
                            child: Image.asset(
                              'assets/test_pictures/cover_art/${widget.index}.jpeg',
                              width: 93,
                              height: 93,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostActions extends StatefulWidget {
  const PostActions({super.key});

  @override
  _PostActionsState createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions>
    with TickerProviderStateMixin {
  bool isLiked = false;
  bool isBookmarked = false;
  late IconAnimationController iconAnimationController;

  @override
  void initState() {
    super.initState();
    iconAnimationController = IconAnimationController(vsync: this);
    iconAnimationController.initLikeAnimation();
    iconAnimationController.initBookmarkAnimation();
  }

  @override
  void dispose() {
    iconAnimationController.dispose();
    super.dispose();
  }

  void _onLikeButtonPressed() {
    setState(() {
      isLiked = !isLiked;
    });
    iconAnimationController.playLikeAnimation();
  }

  void _onBookmarkButtonPressed() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    iconAnimationController.playBookmarkAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ScaleTransition(
          scale: iconAnimationController.likeAnimation,
          child: IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border_outlined,
              color: isLiked ? Colors.red : Colors.white,
            ),
            onPressed: _onLikeButtonPressed,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ),
        const Text(
          '10',
          style: TextStyle(color: Colors.white),
        ),
        IconButton(
          icon: const Icon(
            CupertinoIcons.chat_bubble,
            color: Colors.white,
          ),
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        const Text(
          '10',
          style: TextStyle(color: Colors.white),
        ),
        IconButton(
          icon: const Icon(
            CupertinoIcons.paperplane,
            color: Colors.white,
          ),
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        const Text(
          '10',
          style: TextStyle(color: Colors.white),
        ),
        const Spacer(),
        ScaleTransition(
          scale: iconAnimationController.bookmarkAnimation,
          child: IconButton(
            icon: Icon(
              isBookmarked
                  ? CupertinoIcons.bookmark_fill
                  : CupertinoIcons.bookmark,
              color: Colors.white,
            ),
            onPressed: _onBookmarkButtonPressed,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
