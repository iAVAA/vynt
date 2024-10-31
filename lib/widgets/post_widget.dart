import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final int index;

  const PostWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoRow(index: index),
          const SizedBox(height: 10),
          PostImage(index: index),
          const SizedBox(height: 10),
          const PostActions(),
          const SizedBox(height: 5),
          const Text(
            'Liked by user_x and others',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            'User $index: Sample caption for post #$index...',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final int index;

  const UserInfoRow({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/user_avatar.png'),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Text(
          'User $index',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}

class PostImage extends StatelessWidget {
  final int index;

  const PostImage({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('assets/post_image_$index.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PostActions extends StatelessWidget {
  const PostActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.comment_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.send_outlined, color: Colors.white),
          onPressed: () {},
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}