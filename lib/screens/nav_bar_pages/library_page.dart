import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../controllers/scroll_monitor.dart';
import '../subscreens/library_subscreens/playlist_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        key: const PageStorageKey('library'),
        controller: scrollMonitor.getScrollController('library'),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            forceMaterialTransparency: true,
            pinned: true,
            title: Text(
              'Library',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: textTheme.bodyLarge?.color,
              ),
            ),
            actions: [
              PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    title: 'Add new playlist',
                    onTap: () {},
                    icon: CupertinoIcons.add_circled,
                  ),
                  PullDownMenuItem(
                    title: 'Select',
                    onTap: () {},
                    icon: CupertinoIcons.list_bullet,
                  ),
                  PullDownMenuItem(
                    title: 'Edit toolbar',
                    onTap: () {},
                    icon: CupertinoIcons.list_bullet_below_rectangle,
                  ),
                ],
                buttonBuilder: (context, showMenu) => IconButton(
                  icon: const Icon(CupertinoIcons.add_circled),
                  color: textTheme.bodyLarge?.color,
                  onPressed: showMenu,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              dividerMargin: 0,
              additionalDividerMargin: 0,
              children: <CupertinoListTile>[
                CupertinoListTile.notched(
                  title: Text(
                    'Songs',
                    style: TextStyle(color: textTheme.bodyLarge?.color),
                  ),
                  backgroundColor: colorScheme.secondary,
                  backgroundColorActivated:
                      colorScheme.secondary.withValues(alpha: 0.7),
                  leading: const Icon(
                    CupertinoIcons.music_note,
                    color: CupertinoColors.systemPurple,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile.notched(
                  title: Text(
                    'Artists',
                    style: TextStyle(color: textTheme.bodyLarge?.color),
                  ),
                  backgroundColor: colorScheme.secondary,
                  backgroundColorActivated:
                      colorScheme.secondary.withValues(alpha: 0.7),
                  leading: const Icon(
                    CupertinoIcons.music_mic,
                    color: CupertinoColors.systemPurple,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile.notched(
                  title: Text(
                    'Albums',
                    style: TextStyle(color: textTheme.bodyLarge?.color),
                  ),
                  backgroundColor: colorScheme.secondary,
                  backgroundColorActivated:
                      colorScheme.secondary.withValues(alpha: 0.7),
                  leading: const Icon(
                    CupertinoIcons.square_stack,
                    color: CupertinoColors.systemPurple,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _PlaylistCard(index: index + 1);
                },
                childCount: 10,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
            ),
          ),
          // Bottom padding for nav bar
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 90),
          ),
        ],
      ),
    );
  }
}

class _PlaylistCard extends StatefulWidget {
  final int index;

  const _PlaylistCard({required this.index});

  @override
  State<_PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<_PlaylistCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.share,
          child: const Text('Share'),
        ),
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.play_fill,
          child: const Text('Play'),
        ),
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.shuffle,
          child: const Text('Play Shuffled'),
        ),
        CupertinoContextMenuAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.delete,
          child: const Text('Delete'),
        ),
      ],
      enableHapticFeedback: true,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          _pressController.reverse();
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => PlaylistPage(index: widget.index),
            ),
          );
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover art with gradient overlay
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/test_pictures/cover_art/${widget.index}.jpeg',
                        fit: BoxFit.cover,
                      ),
                      // Subtle gradient overlay at bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Play button overlay bottom-right
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.play_fill,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Playlist ${widget.index}',
                style: TextStyle(
                  color: textTheme.bodyLarge?.color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${widget.index * 3 + 7} songs',
                style: TextStyle(
                  color: textTheme.bodySmall?.color,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
