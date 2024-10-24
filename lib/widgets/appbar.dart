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
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.home,
          color: Colors.white
        ),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.propane,
            color: Colors.white
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}