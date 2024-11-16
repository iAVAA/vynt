import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatData = [
      {'name': 'John Doe', 'message': 'Hey, how are you?', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Jane Smith', 'message': 'Let’s catch up soon!', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
      {'name': 'Mike Ross', 'message': 'Sent a photo', 'avatar': 'https://via.placeholder.com/150'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.separated(
        itemCount: chatData.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          indent: 72.0,
          endIndent: 16.0,
        ),
        itemBuilder: (context, index) {
          final chat = chatData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chat['avatar']!),
                radius: 25,
              ),
              title: Text(
                chat['name']!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                chat['message']!,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              onTap: () {
              },
            ),
          );
        },
      ),
    );
  }
}