import 'dart:convert';
import 'dart:io';
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
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return _firestoreService.getCommentsStream(postId);
  }

  @override
  Stream<List<PostEntity>> getPostsStream() {
    return _firestoreService.getPostsStream().map(
      (List<PostModel> posts) {
        return posts.map((post) => post as PostEntity).toList();
      },
    );
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    final post = await _firestoreService.getPost(postId);
    if (post != null) {
      final likes = List<String>.from(post.likes);
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }
      await _firestoreService.updatePost(postId, {'likes': likes});
    }
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