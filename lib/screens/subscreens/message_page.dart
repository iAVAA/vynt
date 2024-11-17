import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vynt/screens/subscreens/chat_page.dart';

class MessagePage extends StatelessWidget {
  final PageController pageController;

  const MessagePage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    final chatData = [
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg'
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png'
      },
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg'
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png'
      },
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg'
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png'
      },
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg'
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png'
      },
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg'
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png'
      },
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg'
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () {
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        title: const Text(
          'danielecompagnonibusiness',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: const Icon(CupertinoIcons.pencil, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatData.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                backgroundColor: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
                placeholder: 'Search',
                placeholderStyle: const TextStyle(color: Colors.grey),
                itemColor: Colors.grey,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          final chat = chatData[index - 1];
          return ListTile(
            splashColor: Colors.transparent,
            leading: CircleAvatar(
              backgroundImage: AssetImage(chat['avatar']!),
              radius: 25,
            ),
            title: Text(
              chat['name']!,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat['message']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  '1h',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.purple[700],
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
          );
        },
      ),
    );
  }
}