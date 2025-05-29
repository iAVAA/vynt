import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_down_button/pull_down_button.dart';
import 'package:share_plus/share_plus.dart';

import 'package:vynt/controllers/animation_controller.dart';
import 'package:vynt/providers/post_provider.dart';

class PostWidget extends StatefulWidget {
  final int index;

  const PostWidget({required this.index, super.key});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  void _handleDoubleTapLike() {
    // Always show the heart animation on double tap
    // Only increment like count if not already liked
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.likePost(widget.index);
    print('Double tap liked post #${widget.index}');
  }

  void _updateLikeStatus(bool liked, int count) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    if (liked) {
      postProvider.likePost(widget.index);
    } else {
      postProvider.toggleLike(widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        final isLiked = postProvider.isPostLiked(widget.index);
        final likeCount = postProvider.getPostLikeCount(widget.index);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoRow(index: widget.index),
              const SizedBox(height: 10),
              PostImage(
                index: widget.index,
                isLiked: isLiked,
                onDoubleTapLike: _handleDoubleTapLike,
              ),
              const SizedBox(height: 10),
              PostActions(
                isLiked: isLiked,
                likeCount: likeCount,
                onLikeChanged: _updateLikeStatus,
              ),
              const SizedBox(height: 5),
              Text(
                'Liked by user_x and others',
                style:
                    TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 5),
              Text(
                'User ${widget.index}: Sample caption for post #${widget.index}...',
                style:
                    TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 5),
              Text(
                'Posted on 01/01/2022',
                style:
                    TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
              ),
              const SizedBox(height: 25),
            ],
          ),
        );
      },
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
          backgroundImage: AssetImage('assets/test_pictures/test_post.webp'),
          radius: 15,
        ),
        const SizedBox(width: 10),
        Text(
          'User $index',
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        PullDownButton(
          itemBuilder: (context) => [
            PullDownMenuItem(
              title: 'Show Profile',
              onTap: () {},
              icon: CupertinoIcons.profile_circled,
            ),
            PullDownMenuItem(
              title: 'Save to your library',
              onTap: () {},
              icon: CupertinoIcons.music_albums,
            ),
            PullDownMenuItem(
              title: 'Share',
              onTap: () {
                Share.share('check out my website https://example.com',
                    subject: 'Look what I made!');
              },
              icon: CupertinoIcons.share,
            ),
          ],
          buttonBuilder: (context, showMenu) => IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: showMenu,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

class PostImage extends StatefulWidget {
  final int index;
  final bool isLiked;
  final VoidCallback onDoubleTapLike;

  const PostImage(
      {required this.index,
      required this.onDoubleTapLike,
      required this.isLiked,
      super.key});

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> with TickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimation;
  Animation<Matrix4>? _animation;

  bool _showHeartOverlay = false;
  Offset _heartPosition = Offset.zero;

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

    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _heartAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.5), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 40),
    ]).animate(CurvedAnimation(
      parent: _heartAnimationController,
      curve: Curves.easeInOut,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _showHeartOverlay = false;
          });
        }
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    _heartAnimationController.dispose();
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

  void _handleDoubleTap(TapDownDetails details) {
    print("_handleDoubleTap called with position: ${details.localPosition}");
    setState(() {
      _showHeartOverlay = true;
      _heartPosition = details.localPosition;
    });
    widget.onDoubleTapLike();
    _heartAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTap,
      onDoubleTap: () {
        print("Outer GestureDetector onDoubleTap called");
        // This will be called after onDoubleTapDown
        _heartAnimationController.forward(from: 0.0);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Heart overlay animation
            if (_showHeartOverlay)
              Positioned(
                left: _heartPosition.dx - 40,
                top: _heartPosition.dy - 40,
                child: AnimatedBuilder(
                  animation: _heartAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _heartAnimation.value > 0 ? 1.0 : 0.0,
                      child: Transform.scale(
                        scale: _heartAnimation.value,
                        child: Icon(
                          Icons.favorite,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 80,
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Wrap the InteractiveViewer in a GestureDetector to handle double-tap
            GestureDetector(
              onDoubleTap: () {
                print("Middle GestureDetector onDoubleTap called");
                // Get the center position of the container
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final size = renderBox.size;
                final position = Offset(size.width / 2, size.height / 2);

                setState(() {
                  _showHeartOverlay = true;
                  _heartPosition = position;
                });
                widget.onDoubleTapLike();
                _heartAnimationController.forward(from: 0.0);
              },
              child: InteractiveViewer(
                transformationController: _transformationController,
                onInteractionEnd: (details) => _onInteractionEnd(),
                minScale: 1.0,
                maxScale: 4.0,
                // Disable InteractiveViewer's double tap to zoom functionality
                // to prevent conflicts with our double tap to like
                interactionEndFrictionCoefficient: 0.01,
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.asset(
                                'assets/test_pictures/cover_art/${widget.index}.jpeg',
                                width: 93,
                                height: 93,
                              ),
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
  final bool isLiked;
  final int likeCount;
  final Function(bool, int) onLikeChanged;

  const PostActions(
      {required this.isLiked,
      required this.likeCount,
      required this.onLikeChanged,
      super.key});

  @override
  _PostActionsState createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions>
    with TickerProviderStateMixin {
  bool isBookmarked = false;
  late IconAnimationController iconAnimationController;

  @override
  void initState() {
    super.initState();
    iconAnimationController = IconAnimationController(vsync: this);
    iconAnimationController.initLikeAnimation();
    iconAnimationController.initBookmarkAnimation();
    iconAnimationController.initRotationAnimation();
  }

  @override
  void dispose() {
    iconAnimationController.dispose();
    super.dispose();
  }

  void _onLikeButtonPressed() {
    final newLiked = !widget.isLiked;
    final newCount = newLiked ? widget.likeCount + 1 : widget.likeCount - 1;
    widget.onLikeChanged(newLiked, newCount);
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
              widget.isLiked ? Icons.favorite : Icons.favorite_border_outlined,
              color: widget.isLiked
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).iconTheme.color,
            ),
            onPressed: _onLikeButtonPressed,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ),
        Text(
          '${widget.likeCount}',
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.chat_bubble,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        Text(
          '10',
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.paperplane,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        Text(
          '10',
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        const Spacer(),
        ScaleTransition(
          scale: iconAnimationController.bookmarkAnimation,
          child: IconButton(
            icon: Icon(
              isBookmarked
                  ? CupertinoIcons.add_circled_solid
                  : CupertinoIcons.add_circled,
              color: Theme.of(context).iconTheme.color,
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
