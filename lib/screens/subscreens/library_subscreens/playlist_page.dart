import 'package:flutter/material.dart';

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
        child: Text(
          'This is a placeholder for Playlist $index',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}