import 'package:flutter/cupertino.dart';
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
          backgroundImage: AssetImage('assets/test_pictures/daniele_pfp.png'),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Text(
          'User $index',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
        )
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
        image: const DecorationImage(
          image: AssetImage('assets/test_pictures/test_post.webp'),
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
          icon: const Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        IconButton(
          icon: const Icon(
              CupertinoIcons.chat_bubble,
              color: Colors.white
          ),
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        IconButton(
          icon: const Icon(
              CupertinoIcons.paperplane,
              color: Colors.white
          ),
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
              CupertinoIcons.bookmark,
              color: Colors.white
          ),
          onPressed: () {},
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ],
    );
  }
}
