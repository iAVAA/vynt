import 'package:flutter/foundation.dart';

class PostModel {
  final int id;
  bool isLiked;
  int likeCount;

  PostModel({
    required this.id,
    this.isLiked = false,
    this.likeCount = 10,
  });
}

class PostProvider extends ChangeNotifier {
  final Map<int, PostModel> _posts = {};

  // Get a post by id, create it if it doesn't exist
  PostModel getPost(int id) {
    if (!_posts.containsKey(id)) {
      _posts[id] = PostModel(id: id);
    }
    return _posts[id]!;
  }

  // Check if a post is liked
  bool isPostLiked(int id) {
    return getPost(id).isLiked;
  }

  // Get the like count for a post
  int getPostLikeCount(int id) {
    return getPost(id).likeCount;
  }

  // Toggle like status for a post
  Future<void> toggleLike(int id) async {
    final post = getPost(id);
    post.isLiked = !post.isLiked;
    post.likeCount = post.isLiked ? post.likeCount + 1 : post.likeCount - 1;
    
    // Simulate server update
    await _updateLikeOnServer(id, post.isLiked);
    
    notifyListeners();
  }

  // Like a post if not already liked
  Future<void> likePost(int id) async {
    final post = getPost(id);
    if (!post.isLiked) {
      post.isLiked = true;
      post.likeCount++;
      
      // Simulate server update
      await _updateLikeOnServer(id, true);
      
      notifyListeners();
    }
  }

  // Simulate updating like status on server
  Future<void> _updateLikeOnServer(int id, bool isLiked) async {
    // In a real app, this would make an API call to update the server
    // For now, we'll just simulate a delay
    await Future.delayed(const Duration(milliseconds: 300));
    print('Updated like status on server for post #$id: $isLiked');
  }
}