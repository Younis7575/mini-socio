 
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_social/data/models/comment_model.dart';
import 'package:mini_social/domain/entities/post_entity.dart';
 
class PostsResult {
  final List<PostEntity> posts;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  PostsResult({
    required this.posts,
    this.lastDocument,
    required this.hasMore,
  });
}

abstract class PostRepositoryInterface {
  Future<String> createPost({
    required File image,
    required String userId,
    required String userDisplayName,
    required String? userPhotoUrl,
    required String? caption,
  });
   
  Stream<PostsResult> getPostsStream({
    DocumentSnapshot? startAfter,
    int limit = 10,
  });
  
  Future<void> likePost(String postId, String userId);
  Future<void> deletePost(String postId, String imageUrl);
   
  Stream<List<CommentModel>> getCommentsStream(String postId);
  Future<void> addComment(String postId, CommentModel comment);
}