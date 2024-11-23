import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  static const Map<String, List<String>> userPlaylists = {
    "Favorites": ["Pop Hits", "Classic Rock", "Jazz Vibes", "Daniele 1", "Daniele 2"],
    "Workout": ["Beast Mode", "Cardio Mix", "Running Tracks"],
    "Relax": ["Chill Lofi", "Meditation", "Smooth Jazz"],
  };

  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
          'Library',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: userPlaylists.entries.map((entry) {
          final title = entry.key;
          final playlists = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlistName = playlists[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            PlaylistImage(index: index + 1),
                            const SizedBox(height: 8),
                            Text(
                              playlistName,
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
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Image.asset(
        'assets/test_pictures/cover_art/$index.jpeg',
        fit: BoxFit.cover,
      ),
    );
  }
}