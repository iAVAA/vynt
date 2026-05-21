import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vynt/screens/subscreens/chat_page.dart';

class MessagePage extends StatelessWidget {
  final PageController pageController;

  const MessagePage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    final chatData = [
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg',
        'time': '1h',
        'unread': '2',
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png',
        'time': '3h',
        'unread': '0',
      },
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg',
        'time': '1d',
        'unread': '1',
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png',
        'time': '2d',
        'unread': '0',
      },
      {
        'name': 'Michele',
        'message': 'Hai preso 2 punti bonus a reti?',
        'avatar': 'assets/test_pictures/michele_pfp.jpeg',
        'time': '3d',
        'unread': '0',
      },
      {
        'name': 'iava',
        'message': 'Hai preso il tavolino?',
        'avatar': 'assets/test_pictures/iava_pfp.png',
        'time': '4d',
        'unread': '0',
      },
    ];

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        elevation: 0,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: Icon(CupertinoIcons.back, color: textTheme.bodyLarge?.color),
          onPressed: () {
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            color: textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Icon(
              Icons.more_horiz,
              color: textTheme.bodyLarge?.color,
              size: 25,
            ),
            onPressed: () {},
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Icon(
              CupertinoIcons.pencil,
              color: textTheme.bodyLarge?.color,
              size: 23,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatData.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: CupertinoSearchTextField(
                backgroundColor: colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                placeholder: 'Search',
                placeholderStyle: TextStyle(
                  color: textTheme.bodySmall?.color,
                ),
                itemColor:
                    textTheme.bodyMedium?.color ?? Colors.grey,
                style: TextStyle(color: textTheme.bodyMedium?.color),
              ),
            );
          }
          final chat = chatData[index - 1];
          final hasUnread = chat['unread'] != '0';

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              splashColor: colorScheme.secondary.withOpacity(0.3),
              highlightColor: colorScheme.secondary.withOpacity(0.15),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    // Avatar with online indicator
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(chat['avatar']!),
                          radius: 26,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: scaffoldColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    // Name + message
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat['name']!,
                            style: TextStyle(
                              color: textTheme.bodyLarge?.color,
                              fontWeight: hasUnread
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            chat['message']!,
                            style: TextStyle(
                              color: hasUnread
                                  ? textTheme.bodyMedium?.color
                                  : textTheme.bodySmall?.color,
                              fontWeight: hasUnread
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Time + badge
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          chat['time']!,
                          style: TextStyle(
                            color: hasUnread
                                ? colorScheme.tertiary
                                : textTheme.bodySmall?.color,
                            fontSize: 12,
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (hasUnread)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              chat['unread']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}