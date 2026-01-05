
import 'dart:io';
import 'package:mini_social/domain/entities/post_entity.dart';

abstract class PostRepositoryInterface {
  Future<String> createPost({
    required File image,
    required String userId,
    required String userDisplayName,
    required String? userPhotoUrl,
    required String? caption,
  });
  
  Stream<List<PostEntity>> getPostsStream();
  Future<void> likePost(String postId, String userId);
  Future<void> deletePost(String postId, String imageUrl);
}