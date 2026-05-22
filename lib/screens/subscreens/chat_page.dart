import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';

import 'package:vynt/providers/chat_provider.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final String otherUserName;
  final String otherUserId;
  final String? otherUserAvatar;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.otherUserName,
    required this.otherUserId,
    this.otherUserAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final currentUser = types.User(id: chatProvider.currentUserId ?? 'unknown');

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primary,
              backgroundImage: otherUserAvatar != null ? AssetImage(otherUserAvatar!) : null,
              child: otherUserAvatar == null ? Text(otherUserName[0].toUpperCase(), style: const TextStyle(fontSize: 14)) : null,
            ),
            const SizedBox(width: 10),
            Text(
              otherUserName,
              style: TextStyle(
                color: textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: textTheme.bodyLarge?.color),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<List<types.Message>>(
        stream: chatProvider.getMessagesStream(chatId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data ?? [];

          return Chat(
            messages: messages,
            onSendPressed: (types.PartialText message) {
              chatProvider.sendMessage(chatId, message.text);
            },
            user: currentUser,
            theme: DefaultChatTheme(
              inputBackgroundColor: colorScheme.secondary,
              inputTextStyle: TextStyle(color: textTheme.bodyLarge?.color ?? Colors.white, fontSize: 16),
              inputBorderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              inputTextColor: textTheme.bodyLarge?.color ?? Colors.white,
              primaryColor: colorScheme.tertiary,
              backgroundColor: scaffoldColor,
              sentMessageBodyTextStyle: const TextStyle(color: Colors.white),
              receivedMessageBodyTextStyle: TextStyle(color: textTheme.bodyLarge?.color ?? Colors.white),
            ),
          );
        },
      ),
    );
  }
}
