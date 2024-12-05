import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../controllers/scroll_monitor.dart';
import '../subscreens/library_subscreens/playlist_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

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
            child: Column(
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.music_note,
                      color: Colors.white),
                  title: const Text('Genres',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 56.0),
                  child: Divider(color: Colors.white),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.music_note_list,
                      color: Colors.white),
                  title: const Text('All Songs',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 56.0),
                  child: Divider(color: Colors.white),
                ),
                CupertinoListTile(
                  leading:
                      const Icon(CupertinoIcons.person_2, color: Colors.white),
                  title: const Text('Artists',
                      style: TextStyle(color: Colors.white)),
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
