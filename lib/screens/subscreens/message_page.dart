import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vynt/providers/chat_provider.dart';
import 'package:vynt/screens/subscreens/chat_page.dart';

class MessagePage extends StatelessWidget {
  final PageController pageController;

  const MessagePage({super.key, required this.pageController});

  void _showNewChatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatProvider.getUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No users found.', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)));
            }

            final users = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'New Message',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(user['name']?[0]?.toUpperCase() ?? '?'),
                        ),
                        title: Text(user['name'] ?? 'Unknown User', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        subtitle: Text(user['email'] ?? '', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                        onTap: () async {
                          Navigator.pop(context);
                          try {
                            final chatId = await chatProvider.getOrCreateChat(user['uid']);
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    chatId: chatId,
                                    otherUserName: user['name'] ?? 'Unknown',
                                    otherUserId: user['uid'],
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            debugPrint("Error creating chat: $e");
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final chatProvider = Provider.of<ChatProvider>(context);

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
            onPressed: () => _showNewChatSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: CupertinoSearchTextField(
              backgroundColor: colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
              placeholder: 'Search',
              placeholderStyle: TextStyle(
                color: textTheme.bodySmall?.color,
              ),
              itemColor: textTheme.bodyMedium?.color ?? Colors.grey,
              style: TextStyle(color: textTheme.bodyMedium?.color),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatProvider.getChatsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No chats yet.',
                      style: TextStyle(color: textTheme.bodyMedium?.color),
                    ),
                  );
                }

                final chats = snapshot.data!;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return _ChatTile(chat: chat, currentUserId: chatProvider.currentUserId!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends StatefulWidget {
  final Map<String, dynamic> chat;
  final String currentUserId;

  const _ChatTile({required this.chat, required this.currentUserId});

  @override
  State<_ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<_ChatTile> {
  Map<String, dynamic>? otherUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOtherUser();
  }

  Future<void> _fetchOtherUser() async {
    List<dynamic> users = widget.chat['users'] ?? [];
    String? otherUserId = users.firstWhere((id) => id != widget.currentUserId, orElse: () => null);
    if (otherUserId != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(otherUserId).get();
      if (doc.exists) {
        setState(() {
          otherUser = doc.data();
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SizedBox(height: 52, child: Center(child: CircularProgressIndicator())),
      );
    }

    final name = otherUser?['name'] ?? 'Unknown';
    final avatar = otherUser?['avatar']; 
    final lastMessageData = widget.chat['lastMessage'];
    final lastMessageText = lastMessageData?['text'] ?? 'No messages yet';
    
    // For now we assume no unread counter logic is implemented backend-side, so we hide it.
    final hasUnread = false;
    
    // Get timestamp from last message or chat updated time
    Timestamp? timestamp;
    if (lastMessageData != null && lastMessageData['createdAt'] != null) {
      // In chat provider we saved createdAt as int milliseconds. 
      final ms = lastMessageData['createdAt'] as int;
      timestamp = Timestamp.fromMillisecondsSinceEpoch(ms);
    } else {
      timestamp = widget.chat['updatedAt'] as Timestamp?;
    }
    final timeStr = _formatTime(timestamp);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                chatId: widget.chat['id'],
                otherUserName: name,
                otherUserId: otherUser?['uid'] ?? '',
              ),
            ),
          );
        },
        splashColor: colorScheme.secondary.withValues(alpha: 0.3),
        highlightColor: colorScheme.secondary.withValues(alpha: 0.15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: colorScheme.primary,
                radius: 26,
                backgroundImage: avatar != null ? AssetImage(avatar) : null,
                child: avatar == null ? Text(name[0].toUpperCase()) : null,
              ),
              const SizedBox(width: 14),
              // Name + message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: textTheme.bodyLarge?.color,
                        fontWeight: hasUnread ? FontWeight.bold : FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lastMessageText,
                      style: TextStyle(
                        color: hasUnread ? textTheme.bodyMedium?.color : textTheme.bodySmall?.color,
                        fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
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
                    timeStr,
                    style: TextStyle(
                      color: hasUnread ? colorScheme.tertiary : textTheme.bodySmall?.color,
                      fontSize: 12,
                      fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}