import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/scroll_monitor.dart';

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
            expandedHeight: 100.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              centerTitle: true,
              titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.add_circled),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                builder: (context) => PlaylistPage(index: index + 1),
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

class PlaylistPage extends StatelessWidget {
  final int index;

  const PlaylistPage({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist $index'),
      ),
      body: Center(
        child: Text('Details for Playlist $index'),
      ),
    );
  }
}