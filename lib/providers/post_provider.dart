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

  /// Get a post by id, create it if it doesn't exist
  PostModel getPost(int id) {
    if (!_posts.containsKey(id)) {
      _posts[id] = PostModel(id: id);
    }
    return _posts[id]!;
  }

  /// Check if a post is liked
  bool isPostLiked(int id) {
    return getPost(id).isLiked;
  }

  /// Get the like count for a post
  int getPostLikeCount(int id) {
    return getPost(id).likeCount;
  }

  /// Toggle like status for a post (optimistic update)
  Future<void> toggleLike(int id) async {
    final post = getPost(id);
    post.isLiked = !post.isLiked;
    post.likeCount = post.isLiked ? post.likeCount + 1 : post.likeCount - 1;

    // Notify UI immediately (optimistic update)
    notifyListeners();

    // Fire-and-forget server update
    _updateLikeOnServer(id, post.isLiked).catchError((e) {
      // Rollback on error
      post.isLiked = !post.isLiked;
      post.likeCount = post.isLiked ? post.likeCount + 1 : post.likeCount - 1;
      notifyListeners();
    });
  }

  /// Like a post only if not already liked (optimistic update)
  Future<void> likePost(int id) async {
    final post = getPost(id);
    if (!post.isLiked) {
      post.isLiked = true;
      post.likeCount++;

      // Notify UI immediately (optimistic update)
      notifyListeners();

      // Fire-and-forget server update
      _updateLikeOnServer(id, true).catchError((e) {
        // Rollback on error
        post.isLiked = false;
        post.likeCount--;
        notifyListeners();
      });
    }
  }

  /// Simulate updating like status on server
  Future<void> _updateLikeOnServer(int id, bool isLiked) async {
    // In a real app, this would make an API call to update the server
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('Updated like status on server for post #$id: $isLiked');
  }
}