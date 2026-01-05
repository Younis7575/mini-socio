// lib/presentation/controllers/post_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_social/presentation/controllers/auth_controller.dart';
import 'package:mini_social/data/models/post_model.dart';
import 'package:mini_social/data/repositories/post_repository.dart';

class PostController extends GetxController {
  final PostRepository _postRepository;
  
  // Using a getter to ensure we always have the latest AuthController instance
  AuthController get _authController => Get.find<AuthController>();

  PostController({required PostRepository postRepository})
      : _postRepository = postRepository;

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingPost = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPosts();
  }

  void _loadPosts() {
    _postRepository.getPostsStream().listen((postEntities) {
      final postModels = postEntities.map((entity) {
        return PostModel(
          id: entity.id,
          userId: entity.userId,
          userDisplayName: entity.userDisplayName,
          userPhotoUrl: entity.userPhotoUrl,
          imageUrl: entity.imageUrl,
          caption: entity.caption,
          timestamp: entity.timestamp,
          likes: entity.likes,
          commentCount: entity.commentCount,
        );
      }).toList();
      posts.assignAll(postModels);
    });
  }

Future<void> createPost(File image, String? caption) async {
  try {
    isCreatingPost.value = true;
    error.value = '';
    
    // 1. Give the Auth listener a moment to sync if it's null (Wait up to 2 seconds)
    if (_authController.currentUser.value == null) {
      debugPrint("User null, waiting for Auth sync...");
      await Future.delayed(const Duration(seconds: 2));
    }

    final user = _authController.currentUser.value;
    
    // 2. Final check
    if (user == null) {
      throw Exception('Session expired or still loading. Please try again in a moment.');
    }
    
    debugPrint("User authenticated as: ${user.uid}. Proceeding to upload...");

    await _postRepository.createPost(
      image: image,
      userId: user.uid,
      userDisplayName: user.displayName,
      userPhotoUrl: user.photoUrl,
      caption: caption,
    );
    
    Get.back();
    Get.snackbar('Success', 'Post created successfully');
  } catch (e) {
    debugPrint("CREATE POST FAILED: $e");
    error.value = 'Failed to create post: $e';
    Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isCreatingPost.value = false;
  }
}

  Future<void> toggleLike(String postId) async {
    try {
      final user = _authController.currentUser.value;
      if (user == null) return;
      await _postRepository.likePost(postId, user.uid);
    } catch (e) {
      Get.snackbar('Error', 'Failed to like post');
    }
  }

  Future<void> deletePost(String postId, String imageUrl) async {
    try {
      isLoading.value = true;
      await _postRepository.deletePost(postId, imageUrl);
      Get.snackbar('Success', 'Post deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post');
    } finally {
      isLoading.value = false;
    }
  }

  bool canDeletePost(String userId) {
    final currentUser = _authController.currentUser.value;
    return currentUser?.uid == userId;
  }
}