import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Stream of all registered users except the current one (for starting new chats)
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    if (currentUserId == null) return const Stream.empty();
    
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map((doc) => doc.data())
          .toList();
    });
  }

  /// Stream of chats where the current user is a participant
  Stream<List<Map<String, dynamic>>> getChatsStream() {
    if (currentUserId == null) return const Stream.empty();

    return _firestore
        .collection('chats')
        .where('users', arrayContains: currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Stream of messages for a specific chat
  Stream<List<types.Message>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        
        return types.TextMessage(
          id: doc.id,
          author: types.User(id: data['authorId']),
          createdAt: data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
          text: data['text'] ?? '',
        );
      }).toList();
    });
  }

  /// Send a text message
  Future<void> sendMessage(String chatId, String text) async {
    if (currentUserId == null) return;
    
    final messageData = {
      'authorId': currentUserId,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'text': text,
      'type': 'text',
    };

    // Add to messages subcollection
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Update parent chat's last message
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': messageData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Gets an existing chat room or creates a new one between current user and [otherUserId]
  Future<String> getOrCreateChat(String otherUserId) async {
    if (currentUserId == null) throw Exception("User not logged in");

    // Check if a chat already exists
    final querySnapshot = await _firestore
        .collection('chats')
        .where('users', arrayContains: currentUserId)
        .get();

    for (var doc in querySnapshot.docs) {
      List<dynamic> users = doc.data()['users'] ?? [];
      if (users.contains(otherUserId)) {
        return doc.id; // Chat exists
      }
    }

    // Create a new chat
    final newChatRef = await _firestore.collection('chats').add({
      'users': [currentUserId, otherUserId],
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
    });

    return newChatRef.id;
  }
}
