import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.likePost(widget.index);
  }

  void _handleLikeToggle() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.toggleLike(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        final isLiked = postProvider.isPostLiked(widget.index);
        final likeCount = postProvider.getPostLikeCount(widget.index);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
              const SizedBox(height: 8),
              PostActions(
                isLiked: isLiked,
                likeCount: likeCount,
                onLikeToggle: _handleLikeToggle,
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'user_x ',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: 'and others liked this',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'user_${widget.index} ',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: 'Sample caption for post #${widget.index} 🎵',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'View all 10 comments',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '01/01/2022',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 20),
              Divider(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                thickness: 0.5,
              ),
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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/test_pictures/test_post.webp'),
            radius: 18,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'user_$index',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              'Listening now 🎵',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 11,
              ),
            ),
          ],
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
                Share.share(
                  'Check out this post on Vynt!',
                  subject: 'Vynt Post',
                );
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

  const PostImage({
    required this.index,
    required this.onDoubleTapLike,
    required this.isLiked,
    super.key,
  });

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> with TickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _zoomAnimationController;
  late AnimationController _heartAnimationController;
  late AnimationController _heartOpacityController;
  late Animation<double> _heartScaleAnimation;
  late Animation<double> _heartOpacityAnimation;
  Animation<Matrix4>? _zoomAnimation;

  bool _showHeartOverlay = false;
  Offset _heartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    _transformationController = TransformationController();

    // Zoom-back animation after pinch
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        _transformationController.value = _zoomAnimation!.value;
      });

    // Heart scale animation
    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Heart opacity animation
    _heartOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _heartScaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.3), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: _heartAnimationController,
      curve: Curves.easeOut,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            setState(() {
              _showHeartOverlay = false;
            });
          }
        }
      });

    _heartOpacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _heartOpacityController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _zoomAnimationController.dispose();
    _heartAnimationController.dispose();
    _heartOpacityController.dispose();
    super.dispose();
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    if (_transformationController.value != Matrix4.identity()) {
      _zoomAnimation = Matrix4Tween(
        begin: _transformationController.value,
        end: Matrix4.identity(),
      ).animate(CurvedAnimation(
        parent: _zoomAnimationController,
        curve: Curves.easeOut,
      ));
      _zoomAnimationController.forward(from: 0);
    }
  }

  void _handleDoubleTap(TapDownDetails details) {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Trigger the like
    widget.onDoubleTapLike();

    // Show the heart overlay at the tap position
    setState(() {
      _showHeartOverlay = true;
      _heartPosition = details.localPosition;
    });

    // Play animations
    _heartAnimationController.forward(from: 0.0);
    _heartOpacityController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onDoubleTapDown: _handleDoubleTap,
        onDoubleTap: () {}, // Required for onDoubleTapDown to fire
        child: Stack(
          children: [
            // Main interactive image
            InteractiveViewer(
              transformationController: _transformationController,
              onInteractionEnd: _onInteractionEnd,
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

            // Music card overlay (centered)
            Positioned.fill(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.15),
                          width: 1,
                        ),
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

            // Heart overlay animation at tap position
            if (_showHeartOverlay)
              Positioned(
                left: _heartPosition.dx - 45,
                top: _heartPosition.dy - 45,
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _heartAnimationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _heartOpacityAnimation.value,
                        child: Transform.scale(
                          scale: _heartScaleAnimation.value,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white.withOpacity(0.95),
                            size: 90,
                            shadows: [
                              Shadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.8),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
  final VoidCallback onLikeToggle;

  const PostActions({
    required this.isLiked,
    required this.likeCount,
    required this.onLikeToggle,
    super.key,
  });

  @override
  _PostActionsState createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions>
    with TickerProviderStateMixin {
  bool _isBookmarked = false;
  late IconAnimationController _iconAnimationController;
  late AnimationController _likeCountController;
  late Animation<Offset> _likeCountAnimation;


  @override
  void initState() {
    super.initState();
    _iconAnimationController = IconAnimationController(vsync: this);
    _iconAnimationController.initLikeAnimation();
    _iconAnimationController.initBookmarkAnimation();
    _iconAnimationController.initRotationAnimation();

    // Counter slide animation
    _likeCountController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeCountAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _likeCountController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(PostActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.likeCount != widget.likeCount) {
      _likeCountController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _likeCountController.dispose();
    super.dispose();
  }

  void _onLikeButtonPressed() {
    HapticFeedback.lightImpact();
    widget.onLikeToggle();
    _iconAnimationController.playLikeAnimation();
  }

  void _onBookmarkButtonPressed() {
    HapticFeedback.lightImpact();
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    _iconAnimationController.playBookmarkAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ScaleTransition(
          scale: _iconAnimationController.likeAnimation,
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                widget.isLiked
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                key: ValueKey(widget.isLiked),
                color: widget.isLiked
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: _onLikeButtonPressed,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ),
        SlideTransition(
          position: _likeCountAnimation,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              '${widget.likeCount}',
              key: ValueKey(widget.likeCount),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
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
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
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
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        ScaleTransition(
          scale: _iconAnimationController.bookmarkAnimation,
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                _isBookmarked
                    ? CupertinoIcons.add_circled_solid
                    : CupertinoIcons.add_circled,
                key: ValueKey(_isBookmarked),
                color: _isBookmarked
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).iconTheme.color,
              ),
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
