import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatData = [
      {
        'name': 'John Doe',
        'message': 'Hey, how are you?',
        'status': '2 new messages',
        'avatar': 'https://via.placeholder.com/150'
      },
      {
        'name': 'Jane Smith',
        'message': 'Let’s catch up soon!',
        'status': 'Seen',
        'avatar': 'https://via.placeholder.com/150'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'iava_a_',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              backgroundColor: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
              placeholder: 'Search',
              placeholderStyle: const TextStyle(color: Colors.grey),
              itemColor: Colors.grey,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: chatData.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                indent: 72.0,
                endIndent: 16.0,
              ),
              itemBuilder: (context, index) {
                final chat = chatData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chat['avatar']!),
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
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                        if (chat['status'] != null)
                          Text(
                            chat['status']!,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 12),
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.camera_alt, color: Colors.white),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
