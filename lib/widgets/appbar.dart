import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

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
        icon: const Icon(Icons.square, color: Colors.white),
        onPressed: () {
          // Action for the left icon
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.square, color: Colors.white),
          onPressed: () {
            // Action for the right icon
          },
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