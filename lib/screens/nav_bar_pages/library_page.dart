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
            backgroundColor: Colors.grey[900],
            expandedHeight: 80,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Library',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              collapseMode: CollapseMode.parallax,
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
              children: <CupertinoListTile>[
                CupertinoListTile.notched(
                  title: const Text(
                    'Open pull request',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  backgroundColorActivated: Colors.grey.shade700,
                  leading: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: CupertinoColors.activeGreen,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {},
                ),
                CupertinoListTile.notched(
                  title: const Text(
                    'Push to master',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  backgroundColorActivated: Colors.grey.shade700,
                  leading: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: CupertinoColors.systemRed,
                  ),
                  additionalInfo: const Text(
                    'Not available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                CupertinoListTile.notched(
                  title: const Text(
                    'View last commit',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  backgroundColorActivated: Colors.grey.shade700,
                  leading: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: CupertinoColors.activeOrange,
                  ),
                  additionalInfo: const Text(
                    '12 days ago',
                    style: TextStyle(color: Colors.white),
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
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlaylistPage(index: index + 1),
                              ),
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
