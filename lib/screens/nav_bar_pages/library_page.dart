import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: CustomScrollView(
        key: const PageStorageKey('library'),
        controller: scrollMonitor.scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            forceMaterialTransparency: true,
            pinned: true,
            title: Text(
              'Library',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
                  color: Colors.white,
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
              backgroundColor: Colors.grey.shade900,
              dividerMargin: 0,
              additionalDividerMargin: 0,
              children: <CupertinoListTile>[
                CupertinoListTile.notched(
                  title: const Text(
                    'Songs',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  backgroundColorActivated: Colors.grey.shade700,
                  leading: Icon(
                    CupertinoIcons.music_note,
                    color: CupertinoColors.systemPurple,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile.notched(
                  title: const Text(
                    'Artists',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  backgroundColorActivated: Colors.grey.shade700,
                  leading: Icon(
                    CupertinoIcons.music_mic,
                    color: CupertinoColors.systemPurple,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile.notched(
                  title: const Text(
                    'Albums',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  backgroundColorActivated: Colors.grey.shade700,
                  leading: Icon(
                    CupertinoIcons.square_stack,
                    color: CupertinoColors.systemPurple,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      CupertinoContextMenu(
                        actions: [
                          CupertinoContextMenuAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            trailingIcon: CupertinoIcons.share,
                            child: const Text('Share'),
                          ),
                          CupertinoContextMenuAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            trailingIcon: CupertinoIcons.play_fill,
                            child: const Text('Play'),
                          ),
                          CupertinoContextMenuAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            trailingIcon: CupertinoIcons.shuffle,
                            child: const Text('Play Shuffled'),
                          ),
                          CupertinoContextMenuAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            trailingIcon: CupertinoIcons.delete,
                            child: const Text('Delete'),
                          ),
                        ],
                        enableHapticFeedback: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => PlaylistPage(index: index + 1)),
                            );
                          },
                          child: PlaylistImage(index: index + 1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Playlist ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
              childCount: 10,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
          ),
        ],
      ),
    );
  }
}

class PlaylistImage extends StatelessWidget {
  final int index;

  const PlaylistImage({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'assets/test_pictures/cover_art/$index.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
