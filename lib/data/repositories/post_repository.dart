import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/data/services/firestore_service.dart';
import 'package:mini_social/domain/entities/post_entity.dart';
import 'package:mini_social/domain/repositories/post_repository_interface.dart';

class PostRepository implements PostRepositoryInterface {
  final FirestoreService _firestoreService;

  // Notice: We removed FirebaseStorageService as it's no longer needed
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
      // 1. Read the image file as bytes
      final bytes = await image.readAsBytes();

      // 2. Decode and Compress (Essential for Firestore)
      img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) throw Exception("Could not decode image");

      // Resize the image to a maximum width of 800px to keep string size small
      if (decodedImage.width > 800) {
        decodedImage = img.copyResize(decodedImage, width: 800);
      }

      // Convert to a compressed JPG (Quality 70 is a good balance)
      final compressedBytes = img.encodeJpg(decodedImage, quality: 70);

      // 3. Convert bytes to Base64 String
      final String base64Image = base64Encode(compressedBytes);

      // 4. Create the model
      // The 'imageUrl' field will now hold the actual Base64 data string
      final post = PostModel(
        id: '',
        userId: userId,
        userDisplayName: userDisplayName,
        userPhotoUrl: userPhotoUrl,
        imageUrl: base64Image, 
        caption: caption,
        timestamp: DateTime.now(),
      );

      // 5. Save to Firestore
      final postId = await _firestoreService.createPost(post);
      return postId;
    } catch (e) {
      throw Exception('Failed to create post in Firestore: $e');
    }
  }

  @override
  Stream<List<PostEntity>> getPostsStream() {
    return _firestoreService.getPostsStream().map(
          (posts) => posts.map((post) => post as PostEntity).toList(),
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
  Future<void> deletePost(String postId, String imageUrl) async {
    // We only need to delete the document; there is no Storage file to delete
    await _firestoreService.deletePost(postId);
  }
}