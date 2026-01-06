 
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;
import 'package:mini_social/data/models/comment_model.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/data/services/firestore_service.dart';
import 'package:mini_social/domain/entities/post_entity.dart';
import 'package:mini_social/domain/repositories/post_repository_interface.dart';

class PostRepository implements PostRepositoryInterface {
  final FirestoreService _firestoreService;

  PostRepository({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  @override
  Future<String> createPost({
    required File image,
    required String userId,
    required String userDisplayName,
    required String? userPhotoUrl,
    required String? caption,
  }) async {
    try {
      final bytes = await image.readAsBytes();
      img.Image? decodedImage = img.decodeImage(bytes);
      
      if (decodedImage == null) throw Exception("Could not decode image");

      if (decodedImage.width > 800) {
        decodedImage = img.copyResize(decodedImage, width: 800);
      }

      final compressedBytes = img.encodeJpg(decodedImage, quality: 70);
      final String base64Image = base64Encode(compressedBytes);

      final post = PostModel(
        id: '',
        userId: userId,
        userDisplayName: userDisplayName,
        userPhotoUrl: userPhotoUrl,
        imageUrl: base64Image, 
        caption: caption,
        timestamp: DateTime.now(),
      );

      return await _firestoreService.createPost(post);
    } catch (e) {
      throw Exception('Failed to create post in Firestore: $e');
    }
  }

  @override
  Stream<PostsResult> getPostsStream({
    DocumentSnapshot? startAfter,
    int limit = 10,
  }) async* { 
    var query = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .limit(limit);
 
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
 
    await for (final snapshot in query.snapshots()) {
      final posts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PostModel(
          id: doc.id,
          userId: data['userId'],
          userDisplayName: data['userDisplayName'],
          userPhotoUrl: data['userPhotoUrl'],
          imageUrl: data['imageUrl'],
          caption: data['caption'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          likes: List<String>.from(data['likes'] ?? []),
          commentCount: data['commentCount'] ?? 0,
        ) as PostEntity;
      }).toList();

      final lastDocument = snapshot.docs.isNotEmpty 
          ? snapshot.docs.last 
          : null;
      
      final hasMore = posts.length == limit;

      yield PostsResult(
        posts: posts,
        lastDocument: lastDocument,
        hasMore: hasMore,
      );
    }
  }

  @override
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return _firestoreService.getCommentsStream(postId);
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    await _firestoreService.likePost(postId, userId);
  }

  @override
  Future<void> addComment(String postId, CommentModel comment) async {
    await _firestoreService.addComment(postId, comment);
  }

  @override
  Future<void> deletePost(String postId, String imageUrl) async {
    await _firestoreService.deletePost(postId);
  }
}