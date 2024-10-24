import 'package:flutter/material.dart';

class ApplicationBar extends StatelessWidget {
  final String title;

  const ApplicationBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      pinned: true,
      forceMaterialTransparency: true,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.home,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.propane,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.5),
              Colors.transparent.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }
}